const std = @import("std");
const rl = @import("./raylib.zig");

pub fn fix_zero(x: f32) f32 {
    const err = 1e-7;
    if (-err < x and x < err) return 0;
    return x;
}

pub fn v3_rotate_z(v: rl.Vector3, angle: f32) rl.Vector3 {
    var v2: rl.Vector3 = undefined;

    v2.x = fix_zero(v.x * @cos(angle) - v.y * @sin(angle));
    v2.y = fix_zero(v.x * @sin(angle) + v.y * @cos(angle));
    v2.z = v.z;

    return v2;
}

pub fn v3_rotate_y(v: rl.Vector3, angle: f32) rl.Vector3 {
    var v2: rl.Vector3 = undefined;

    v2.x = fix_zero(v.x * @cos(angle) - v.z * @sin(angle));
    v2.y = v.y;
    v2.z = fix_zero(v.x * @sin(angle) + v.z * @cos(angle));

    return v2;
}

pub fn v3_rotate_x(v: rl.Vector3, angle: f32) rl.Vector3 {
    var v2: rl.Vector3 = undefined;

    v2.x = v.x;
    v2.y = fix_zero(v.y * @cos(angle) - v.z * @sin(angle));
    v2.z = fix_zero(v.y * @sin(angle) + v.z * @cos(angle));

    return v2;
}

const Face = struct {
    direction: rl.Vector3,
    color: rl.Color,
};

const Faces = union(enum) {
    zero: void,
    one: Face,
    two: [2]Face,
    three: [3]Face,

    fn make_zero() Faces {
        return Faces { .zero = void{} };
    }

    fn make_one(dir: rl.Vector3, c: rl.Color) Faces {
        return Faces {
            .one = Face {
                .direction = dir,
                .color = c,
            }
        };
    }

    fn make_two(
        dir1: rl.Vector3, c1: rl.Color,
        dir2: rl.Vector3, c2: rl.Color
    ) Faces {
        const f1 = Face { .direction = dir1, .color = c1 };
        const f2 = Face { .direction = dir2, .color = c2 };

        return Faces {
            .two = [2]Face{ f1, f2 }
        };
    }

    fn make_three(
        dir1: rl.Vector3, c1: rl.Color,
        dir2: rl.Vector3, c2: rl.Color,
        dir3: rl.Vector3, c3: rl.Color
    ) Faces {
        const f1 = Face { .direction = dir1, .color = c1 };
        const f2 = Face { .direction = dir2, .color = c2 };
        const f3 = Face { .direction = dir3, .color = c3 };

        return Faces {
            .three = [3]Face{ f1, f2, f3 }
        };
    }
};

const Cube = struct {
    position: rl.Vector3,
    faces: Faces,

    fn rotate_x(cube: *Cube, ang: f32) void {
        cube.position = v3_rotate_x(cube.position, ang);

        switch (cube.faces) {
            .one => |*f| {
                f.direction = v3_rotate_x(f.direction, ang);
            },
            .two => |*fs| {
                fs[0].direction = v3_rotate_x(fs[0].direction, ang);
                fs[1].direction = v3_rotate_x(fs[1].direction, ang);
            },
            .three => |*fs| {
                fs[0].direction = v3_rotate_x(fs[0].direction, ang);
                fs[1].direction = v3_rotate_x(fs[1].direction, ang);
                fs[2].direction = v3_rotate_x(fs[2].direction, ang);
            },
            else => {},
        }
    }

    fn rotate_y(cube: *Cube, ang: f32) void {
        cube.position = v3_rotate_y(cube.position, ang);

        switch (cube.faces) {
            .one => |*f| {
                f.direction = v3_rotate_y(f.direction, ang);
            },
            .two => |*fs| {
                fs[0].direction = v3_rotate_y(fs[0].direction, ang);
                fs[1].direction = v3_rotate_y(fs[1].direction, ang);
            },
            .three => |*fs| {
                fs[0].direction = v3_rotate_y(fs[0].direction, ang);
                fs[1].direction = v3_rotate_y(fs[1].direction, ang);
                fs[2].direction = v3_rotate_y(fs[2].direction, ang);
            },
            else => {},
        }
    }

    fn rotate_z(cube: *Cube, ang: f32) void {
        cube.position = v3_rotate_z(cube.position, ang);

        switch (cube.faces) {
            .one => |*f| {
                f.direction = v3_rotate_z(f.direction, ang);
            },
            .two => |*fs| {
                fs[0].direction = v3_rotate_z(fs[0].direction, ang);
                fs[1].direction = v3_rotate_z(fs[1].direction, ang);
            },
            .three => |*fs| {
                fs[0].direction = v3_rotate_z(fs[0].direction, ang);
                fs[1].direction = v3_rotate_z(fs[1].direction, ang);
                fs[2].direction = v3_rotate_z(fs[2].direction, ang);
            },
            else => {},
        }
    }
};

pub fn main() void {
    const screen_width = 800;
    const screen_height = 600;

    rl.init_window(screen_width, screen_height, "Rubik's");

    defer rl.close_window();

    // const rect = rl.make_rect(300, 200, 200, 200);

    var camera: rl.Camera3D = undefined;
    camera.position = rl.make_v3(12.0, 8.0, 12.0);
    camera.target = rl.make_v3(0.0, 0.0, 0.0);
    camera.up = rl.make_v3(0.0, 1.0, 0.0);
    camera.fovy = 45.0;
    camera.projection = rl.CAMERA_PERSPECTIVE;

    var cubes: [27]Cube = undefined;

    const size = 2.0;
    const gap = 0.0;

    var pos: usize = 0;

    for (0..3) |i| {
        const x_face_dir = rl.make_v3(
            @as(f32, @floatFromInt(i)) - 1.0,
            0.0,
            0.0,
        );

        const x_face_color = switch (i) {
            0 => rl.Green,
            2 => rl.Blue,
            else => rl.Black,
        };

        for (0..3) |j| {
            const y_face_dir = rl.make_v3(
                0.0,
                @as(f32, @floatFromInt(j)) - 1.0,
                0.0,
            );

            const y_face_color = switch (j) {
                0 => rl.Red,
                2 => rl.Orange,
                else => rl.Black,
            };

            for (0..3) |k| {
                const z_face_dir = rl.make_v3(
                    0.0,
                    0.0,
                    @as(f32, @floatFromInt(k)) - 1.0,
                );

                const z_face_color = switch (k) {
                    0 => rl.Yellow,
                    2 => rl.White,
                    else => rl.Black,
                };

                var faces: Faces = Faces.make_zero();

                if (i == 1) {
                    if (j != 1 and k != 1) {
                        faces = Faces.make_two(
                            y_face_dir, y_face_color,
                            z_face_dir, z_face_color
                        );
                    } else if (j != 1 and k == 1) {
                        faces = Faces.make_one(
                            y_face_dir, y_face_color
                        );
                    } else if (j == 1 and k != 1) {
                        faces = Faces.make_one(
                            z_face_dir, z_face_color
                        );
                    }
                } else {
                    if (j != 1 and k != 1) {
                        faces = Faces.make_three(
                            x_face_dir, x_face_color,
                            y_face_dir, y_face_color,
                            z_face_dir, z_face_color
                        );
                    } else if (j != 1 and k == 1) {
                        faces = Faces.make_two(
                            x_face_dir, x_face_color,
                            y_face_dir, y_face_color
                        );
                    } else if (j == 1 and k != 1) {
                        faces = Faces.make_two(
                            x_face_dir, x_face_color,
                            z_face_dir, z_face_color
                        );
                    } else if (j == 1 and k == 1) {
                        faces = Faces.make_one(
                            x_face_dir, x_face_color
                        );
                    }
                }

                const position = rl.make_v3(
                    (@as(f32, @floatFromInt(i)) - 1.0) * (size + gap),
                    (@as(f32, @floatFromInt(j)) - 1.0) * (size + gap),
                    (@as(f32, @floatFromInt(k)) - 1.0) * (size + gap),
                );

                cubes[pos] = Cube { .position = position, .faces = faces };

                pos += 1;
            }
        }
    }


    // rl.disable_cursor();
    rl.set_target_fps(60);

    while (!rl.window_should_close()) {
        rl.begin_drawing();
            rl.begin_mode_3d(camera);
                rl.clear_background(rl.Beige);

                if (rl.is_key_down('Q')) {
                    const start_pos = rl.make_v3(0, -3 * size, 0);
                    const end_pos = rl.make_v3(0, 3 * size, 0);
                    rl.draw_cylinder_ex(start_pos, end_pos, 0.15, 0.15, 20, rl.Maroon);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_y(ang);
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_y(ang);
                        }
                    }
                } else if (rl.is_key_down('A')) {
                    const start_pos = rl.make_v3(-3 * size, 0, 0);
                    const end_pos = rl.make_v3(3 * size, 0, 0);
                    rl.draw_cylinder_ex(start_pos, end_pos, 0.15, 0.15, 20, rl.Maroon);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_x(ang);
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_x(ang);
                        }
                    }
                } else if (rl.is_key_down('Z')) {
                    const start_pos = rl.make_v3(0, 0, -3 * size);
                    const end_pos = rl.make_v3(0, 0, 3 * size);
                    rl.draw_cylinder_ex(start_pos, end_pos, 0.15, 0.15, 20, rl.Maroon);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_z(ang);
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            cube.rotate_z(ang);
                        }
                    }
                }

                for (cubes) |cube| {
                    rl.draw_cube(cube.position, 2.0, 2.0, 2.0, rl.Black);
                    // rl.draw_cube_wires(cube.position, 2.0, 2.0, 2.0, rl.Black);

                    const face_sz = rl.make_v3(1.6, 1.6, 1.6);
                    const factor = -1.5;
                    // const face_sz = rl.make_v3(0.5, 0.5, 0.5);
                    // const factor = -0.4;

                    switch (cube.faces) {
                        .one => |f| {
                            const p = rl.v3_add(cube.position, f.direction);
                            const n = rl.v3_scale(f.direction, f.direction);

                            const s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, f.color);
                        },
                        .two => |fs| {
                            var p = rl.v3_add(cube.position, fs[0].direction);
                            var n = rl.v3_scale(fs[0].direction, fs[0].direction);
                            var s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, fs[0].color);

                            p = rl.v3_add(cube.position, fs[1].direction);
                            n = rl.v3_scale(fs[1].direction, fs[1].direction);
                            s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, fs[1].color);
                        },
                        .three => |fs| {
                            var p = rl.v3_add(cube.position, fs[0].direction);
                            var n = rl.v3_scale(fs[0].direction, fs[0].direction);
                            var s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, fs[0].color);

                            p = rl.v3_add(cube.position, fs[1].direction);
                            n = rl.v3_scale(fs[1].direction, fs[1].direction);
                            s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, fs[1].color);

                            p = rl.v3_add(cube.position, fs[2].direction);
                            n = rl.v3_scale(fs[2].direction, fs[2].direction);
                            s = rl.v3_add(face_sz, rl.v3_times(n, factor));
                            rl.draw_cube(p, s.x, s.y, s.z, fs[2].color);
                        },
                        else => {},
                    }
                }

                if (rl.is_key_down('V')) {
                    const start_pos = rl.make_v3(0, 0, (size + gap));
                    const end_pos = rl.make_v3(0, 0, (size + gap) + 0.02);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z > 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z > 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('C')) {
                    const start_pos = rl.make_v3(0, 0, 0);
                    const end_pos = rl.make_v3(0, 0, 0.02);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z == 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z == 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('X')) {
                    const start_pos = rl.make_v3(0, 0, -(size + gap));
                    const end_pos = rl.make_v3(0, 0, -(size + gap) + 0.02);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z < 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.z < 0) {
                                cube.rotate_z(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('S')) {
                    const start_pos = rl.make_v3(-(size + gap), 0, 0);
                    const end_pos = rl.make_v3(-(size + gap) + 0.02, 0, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x < 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x < 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('D')) {
                    const start_pos = rl.make_v3(0, 0, 0);
                    const end_pos = rl.make_v3(0.02, 0, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x == 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x == 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('F')) {
                    const start_pos = rl.make_v3((size + gap), 0, 0);
                    const end_pos = rl.make_v3((size + gap) + 0.02, 0, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x > 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.x > 0) {
                                cube.rotate_x(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('W')) {
                    const start_pos = rl.make_v3(0, -(size + gap), 0);
                    const end_pos = rl.make_v3(0, -(size + gap) + 0.02, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y < 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y < 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('E')) {
                    const start_pos = rl.make_v3(0, 0, 0);
                    const end_pos = rl.make_v3(0, 0.02, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y == 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y == 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    }
                } else if (rl.is_key_down('R')) {
                    const start_pos = rl.make_v3(0, (size + gap), 0);
                    const end_pos = rl.make_v3(0, (size + gap) + 0.02, 0);
                    rl.draw_cylinder_wires_ex(start_pos, end_pos, 4.5, 4.5, 40, rl.Magenta);

                    if (rl.is_key_pressed(rl.KeyLeft)) {
                        const ang = std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y > 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    } else if (rl.is_key_pressed(rl.KeyRight)) {
                        const ang = -std.math.pi / 2.0;

                        for (&cubes) |*cube| {
                            if (cube.position.y > 0) {
                                cube.rotate_y(ang);
                            }
                        }
                    }
                }

                // rl.draw_grid(10, 1.0);

            rl.end_mode_3d();

        //     rl.clear_background(rl.Blue);

        //     rl.draw_rectangle_rec(rect, rl.Yellow);
        rl.end_drawing();
    }
}
