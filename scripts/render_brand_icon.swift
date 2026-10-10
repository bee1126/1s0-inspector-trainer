// Deterministic vector artwork; Apple frameworks only. Run from the repository root.
import AppKit
import Foundation
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let output = root.appendingPathComponent("AppStoreAssets/safetyfluent")
let catalog = root.appendingPathComponent("1S0 Inspector Trainer/Resources/Assets.xcassets/AppIcon.appiconset")
func color(_ hex: UInt32) -> CGColor { CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [CGFloat((hex >> 16) & 255)/255, CGFloat((hex >> 8) & 255)/255, CGFloat(hex & 255)/255, 1])! }
func render(_ size: Int, _ variant: String, _ url: URL) {
    let c = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: size*4, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    c.scaleBy(x: CGFloat(size)/1024, y: CGFloat(size)/1024)
    c.translateBy(x: 0, y: 1024); c.scaleBy(x: 1, y: -1)
    c.setFillColor(color(variant == "dark" ? 0x090D13 : 0x101821)); c.fill(CGRect(x: 0,y: 0,width:1024,height:1024))
    let shield = CGMutablePath()
    shield.move(to: CGPoint(x:512,y:178)); shield.addCurve(to:CGPoint(x:780,y:272), control1:CGPoint(x:603,y:220),control2:CGPoint(x:690,y:252))
    shield.addLine(to:CGPoint(x:780,y:466)); shield.addCurve(to:CGPoint(x:512,y:835),control1:CGPoint(x:780,y:635),control2:CGPoint(x:678,y:762))
    shield.addCurve(to:CGPoint(x:244,y:466),control1:CGPoint(x:346,y:762),control2:CGPoint(x:244,y:635));shield.addLine(to:CGPoint(x:244,y:272))
    shield.addCurve(to:CGPoint(x:512,y:178),control1:CGPoint(x:334,y:252),control2:CGPoint(x:421,y:220));shield.closeSubpath()
    c.addPath(shield); c.setFillColor(color(variant == "tinted" ? 0x41464C : 0x103E36));c.fillPath()
    c.addPath(shield);c.setStrokeColor(color(variant == "tinted" ? 0xEEEEEE : 0x00E6A1));c.setLineWidth(42);c.setLineJoin(.round);c.strokePath()
    c.move(to:CGPoint(x:370,y:499));c.addLine(to:CGPoint(x:471,y:600));c.addLine(to:CGPoint(x:660,y:411));c.setStrokeColor(color(variant == "tinted" ? 0xFFFFFF : 0xFFB800));c.setLineWidth(68);c.setLineCap(.round);c.setLineJoin(.round);c.strokePath()
    c.setFillColor(color(variant == "tinted" ? 0xA0A0A0 : 0xFF3B5C));c.fillEllipse(in:CGRect(x:498,y:714,width:28,height:28))
    let rep = NSBitmapImageRep(cgImage: c.makeImage()!)
    try! rep.representation(using:.png,properties:[:])!.write(to:url)
}
let sizes = [20,29,40,58,60,76,80,87,120,152,167,180,1024]
for size in sizes {render(size,"light",catalog.appendingPathComponent("AppIcon-\(size).png"))}
render(1024,"dark",catalog.appendingPathComponent("AppIcon-Dark.png"));render(1024,"tinted",catalog.appendingPathComponent("AppIcon-Tinted.png"))
render(1024,"light",output.appendingPathComponent("AppIcon-1024.png"));render(1024,"light",root.appendingPathComponent("docs/app-icon.png"))
