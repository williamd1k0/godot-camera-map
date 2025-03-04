# Godot Camera Map

This is a random experiment I tried in Godot: using a texture to manipulate some camera properties (like zoom, offset and rotation).

https://github.com/user-attachments/assets/7817f387-01fd-408d-b6b5-36f5aceb2a21

The concept is quite simple, it just maps the camera position into a texture and then convert its rgba values into predefined ranges for offset (RG), zoom (B) and rotation (A).

https://github.com/user-attachments/assets/99daf6c0-5c92-4057-8db8-d6135e2752c2
> [!TIP]
> To view the camera maps at runtime, enable `Debug` -> `Visible Navigation`.


> [!WARNING]  
> As this project was only intended as an experiment, further testing and optimisation may be required before it can be used in production.
