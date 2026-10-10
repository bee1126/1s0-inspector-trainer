#!/usr/bin/env python3
"""Frame real XCTest captures in Grace's approved store order (never synthesize UI).
Usage: python3 scripts/prepare_store_screenshots.py ATTACHMENTS_DIR iphone-6.9|ipad-13
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import sys,json,hashlib,re
root=Path(__file__).resolve().parents[1]
src=Path(sys.argv[1]); family=sys.argv[2]
size=(1320,2868) if family=='iphone-6.9' else (2064,2752)
items=[('today','today','Safety training put into practice, five minutes a day'),('picker','track-picker','OSHA or Air Force. Pick your track.'),('airforce','learn','Bite-size modules, from LOTO to confined space'),('builder','session-builder','Build your own study or exam session'),('debrief','exam-debrief',"See exactly where you're strong and where you're not"),('quiz','question-explanation','Every answer explained, with the official reference'),('progress','progress','XP, streaks, and levels that keep you coming back')]
if family=='ipad-13':items=[items[i] for i in [0,2,3,4,6]]
manifest=json.loads((src/'manifest.json').read_text())
attachments=[a for t in manifest if 'testScreenshots' in t['testIdentifier'] for a in t['attachments']]
out=root/'AppStoreAssets/safetyfluent/screenshots'/family;raw=out/'raw';raw.mkdir(parents=True,exist_ok=True)
records=[]
for index,(key,slug,caption) in enumerate(items,1):
    matches=[a for a in attachments if a['suggestedHumanReadableName'].startswith(key+'_') or a['suggestedHumanReadableName']==key+'.png']
    if len(matches)!=1:raise RuntimeError((key,matches,attachments))
    a=matches[0]; im=Image.open(src/a['exportedFileName']).convert('RGB');assert im.size==size,(key,im.size,size)
    filename=f'{index:02d}-{slug}.png';im.save(raw/filename)
    w,h=size; frame=Image.new('RGB',size,'#101821');draw=ImageDraw.Draw(frame)
    pad=int(w*.065); brandfont=ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial Bold.ttf',int(w*.028))
    titlefont=ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial Bold.ttf',int(w*.050 if family=='iphone-6.9' else w*.043))
    icon=Image.open(root/'AppStoreAssets/safetyfluent/AppIcon-1024.png').convert('RGB');iconsize=int(w*.065);icon=icon.resize((iconsize,iconsize),Image.Resampling.LANCZOS)
    frame.paste(icon,(pad,pad));draw.text((pad+iconsize+int(w*.02),pad+int(w*.016)),'SafetyFluent',font=brandfont,fill='#00E6A1')
    lines=[];line=''
    for word in caption.split():
        test=(line+' '+word).strip()
        if draw.textlength(test,font=titlefont)>w-2*pad and line:lines.append(line);line=word
        else:line=test
    if line:lines.append(line)
    y=pad+iconsize+int(w*.045)
    for line in lines:draw.text((pad,y),line,font=titlefont,fill='#E8EDF1');y+=int(titlefont.size*1.2)
    y+=int(w*.055)
    available=h-y-pad
    scale=min((w-2*pad)/w,available/h)
    sw,sh=int(w*scale),int(h*scale)
    shot=im.resize((sw,sh),Image.Resampling.LANCZOS);x=(w-sw)//2
    draw.rounded_rectangle((x-5,y-5,x+sw+5,y+sh+5),radius=int(w*.025),fill='#39434E')
    frame.paste(shot,(x,y));frame.save(out/filename)
    records.append({'order':index,'file':filename,'caption':caption,'screen':key,'dimensions':list(size),'mode':'RGB','raw':'raw/'+filename,'sha256':hashlib.sha256((out/filename).read_bytes()).hexdigest(),'sourceAttachment':a})
(out/'manifest.json').write_text(json.dumps({'family':family,'sourceResultAttachments':str(src),'screenshots':records},indent=2)+'\n')
print(f'{family}: {len(records)} framed screenshots and original captures verified at {size}, RGB')
