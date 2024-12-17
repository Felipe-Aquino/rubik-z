const c = @cImport({
    @cInclude("raylib.h");
});

pub const Rectangle = c.Rectangle;
pub const Vector3 = c.Vector3;
pub const Color = c.Color;

pub const Yellow = c.YELLOW;
pub const White = c.WHITE;
pub const Red = c.RED;
pub const Blue = c.BLUE;
pub const Black = c.BLACK;
pub const Green = c.GREEN;
pub const Maroon = c.MAROON;
pub const Orange = c.ORANGE;
pub const Beige = c.BEIGE;
pub const Purple = c.PURPLE;
pub const Magenta = c.MAGENTA;

pub const init_window = c.InitWindow;
pub const close_window = c.CloseWindow;
pub const set_target_fps = c.SetTargetFPS;
pub const window_should_close = c.WindowShouldClose;

pub const disable_cursor = c.DisableCursor;

pub const CAMERA_PERSPECTIVE = c.CAMERA_PERSPECTIVE;
pub const CAMERA_ORTHOGRAPHIC = c.CAMERA_ORTHOGRAPHIC;
pub const CAMERA_FREE = c.CAMERA_FREE;
pub const CAMERA_THIRD_PERSON = c.CAMERA_THIRD_PERSON;

pub const Camera3D = c.Camera3D;
pub const update_camera = c.UpdateCamera;

pub const begin_mode_3d = c.BeginMode3D;
pub const end_mode_3d = c.EndMode3D;

pub const draw_cube = c.DrawCube;
pub const draw_cube_wires = c.DrawCubeWires;
pub const draw_grid = c.DrawGrid;
pub const draw_cylinder_ex = c.DrawCylinderEx;
pub const draw_cylinder_wires_ex = c.DrawCylinderWiresEx;


pub const begin_drawing = c.BeginDrawing;
pub const end_drawing = c.EndDrawing;
pub const clear_background =c.ClearBackground;

pub const draw_rectangle_rec = c.DrawRectangleRec;

pub const KeyLeft = c.KEY_LEFT;
pub const KeyRight = c.KEY_RIGHT;
pub const KeyDown = c.KEY_DOWN;
pub const KeyUp = c.KEY_UP;

pub const is_key_pressed = c.IsKeyPressed;
pub const is_key_down = c.IsKeyDown;

pub fn make_rect(x: f32, y: f32, w: f32, h: f32) Rectangle {
    var rect: c.Rectangle = undefined;

    rect.x = x;
    rect.y = y;
    rect.width = w;
    rect.height = h;

    return rect;
}

pub fn make_v3(x: f32, y: f32, z: f32) Vector3 {
    var v3: c.Vector3 = undefined;

    v3.x = x;
    v3.y = y;
    v3.z = z;

    return v3;
}

pub fn v3_add(v1: Vector3, v2: Vector3) Vector3 {
    var v3: c.Vector3 = undefined;

    v3.x = v1.x + v2.x;
    v3.y = v1.y + v2.y;
    v3.z = v1.z + v2.z;

    return v3;
}

pub fn v3_times(v: Vector3, cte: f32) Vector3 {
    var v3: c.Vector3 = undefined;

    v3.x = v.x * cte;
    v3.y = v.y * cte;
    v3.z = v.z * cte;

    return v3;
}

pub fn v3_scale(v1: Vector3, v2: Vector3) Vector3 {
    var v3: c.Vector3 = undefined;

    v3.x = v1.x * v2.x;
    v3.y = v1.y * v2.y;
    v3.z = v1.z * v2.z;

    return v3;
}
