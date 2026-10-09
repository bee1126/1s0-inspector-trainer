"""Regression checks for multipart screenshot delivery and failed-asset cleanup."""
import hashlib
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

import asc_release as asc


class ScreenshotUploadTests(unittest.TestCase):
    def run_upload(self, final_state='COMPLETE', upload_error=None):
        content = b'abcdefgh'
        client = Mock()
        client.request.side_effect = [
            {'data': {'id': 'shot', 'attributes': {'uploadOperations': [
                {'offset': offset, 'length': 4, 'url': 'https://upload.example/part',
                 'method': 'PUT', 'requestHeaders': [{'name': 'X-Part', 'value': str(offset)}]}
                for offset in (0, 4)]}}},
            {},
            {'data': {'id': 'shot', 'attributes': {'assetDeliveryState': {'state': final_state}}}},
            {},
        ]
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'shot.png'
            path.write_bytes(content)
            with patch.object(asc.urllib.request, 'urlopen') as upload:
                if upload_error:
                    upload.side_effect = upload_error
                if final_state == 'COMPLETE' and not upload_error:
                    result = asc.upload_screenshot(client, 'set', path)
                    self.assertEqual(result['id'], 'shot')
                    self.assertEqual([call.args[0].data for call in upload.call_args_list],
                                     [b'abcd', b'efgh'])
                    for call in upload.call_args_list:
                        self.assertIsNone(call.args[0].get_header('Authorization'))
                    commit = client.request.call_args_list[1].kwargs['body']['data']['attributes']
                    self.assertEqual(commit, {'uploaded': True, 'sourceFileChecksum': hashlib.md5(content).hexdigest()})
                else:
                    with self.assertRaises(asc.AscError):
                        asc.upload_screenshot(client, 'set', path)
                    self.assertEqual(client.request.call_args.args, ('DELETE', '/appScreenshots/shot'))

    def test_multipart_and_checksum(self):
        self.run_upload()

    def test_processing_failure_cleanup(self):
        self.run_upload(final_state='FAILED')

    def test_network_failure_cleanup(self):
        self.run_upload(upload_error=asc.urllib.error.URLError('offline'))


if __name__ == '__main__':
    unittest.main()
