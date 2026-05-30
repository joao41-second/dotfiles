# openscad.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin for previewing various geometry formats.
Supported formats are SCAD, CSG, 3MF, AMF, DXF, OFF and STL.

![image](/img.png)

## Requirements
OpenSCAD needs to be installed.

## Installation

```sh
ya pkg add ettom/openscad
```

And add this to `yazi.toml`:

```toml
[plugin]
  prepend_preloaders = [
    # 3D models with OpenSCAD
    { url = "*.{scad,csg,3mf,amf,dxf,off,stl}", run = "openscad" },
  ]
  prepend_previewers = [
    # 3D models with OpenSCAD
    { url = "*.{scad,csg,3mf,amf,dxf,off,stl}", run = "openscad" },
  ]
```
