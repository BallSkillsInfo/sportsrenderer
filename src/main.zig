const std = @import("std");
const zm = @import("zmath");

const Box = @import("shapes/box.zig");

const ColorFmt = enum { monochrome1, monochrome2, monochrome4, monochrome8, rg16, rb16, gb16, rgb3, rgb6, rgb9, rgb12, rgb15, rgb18, rgb24, rgbi4 };

const Color = union(ColorFmt) {
    monochrome1: u1,
    monochrome2: u2,
    monochrome4: u4,
    monochrome8: u8,
    rg16: packed struct { r: u8, g: u8 },
    rb16: packed struct { r: u8, b: u8 },
    gb16: packed struct { g: u8, b: u8 },
    rgb3: packed struct { r: u1, g: u1, b: u1 },
    rgb6: packed struct { r: u2, g: u2, b: u2 },
    rgb9: packed struct { r: u3, g: u3, b: u3 },
    rgb12: packed struct { r: u4, g: u4, b: u4 },
    rgb15: packed struct { r: u5, g: u5, b: u5 },
    rgb18: packed struct { r: u6, g: u6, b: u6 },
    rgb24: packed struct { r: u8, g: u8, b: u8 },
    rgbi4: packed struct { r: u4, g: u4, b: u4, i: u4 },
};

const Material = packed struct { reflectance: f32, emittance: f32 };

const RoundObj = packed struct {
    radius: u16,
    material: Material,
};

const Geometry = union(enum) {
    box: packed struct {
        width: u16,
        height: u16,
        length: u16,
    },
    plane: packed struct { width: u16, height: u16 },
    rounded: RoundObj,
    sphere: RoundObj,

    pub fn intersects(self: *Geometry, ray: *Ray) bool {}
};

const Object = packed struct {
    geometry: Geometry,
    position: zm.Vec,
};

const Light = packed struct {
    position: zm.Vec,
    color: Color,
    luminosity: f32,
};

const Scene = struct {
    objects: std.ArrayList(Object),
    lights: std.ArrayList(Light),

    pub fn randomUnitVectorInHemisphereOf(self: *Scene, vec: zm.Vec) zm.Vec {}
    pub fn findNearestObject(self: *Scene, ray: *Ray) Light!?Object {
        var closestObj = null;
        for (self.objects) |obj| {
            if (obj.intersects(ray)) {
                if (closestObj == null) {
                    closestObj = obj;
                }
            }
        }
        if (closestObj != null) {
            return closestObj.?;
        }
        return error{this};
    }
};

const Ray = struct {
    direction: zm.Vec,
    hit: *?Object,
    normal: zm.Vec,
    normalWhereObjWasHit: zm.Vec,
    pointWhereObjWasHit: zm.Vec,
};

const ImageFmt = struct {
    color: ColorFmt,
    width: u16,
    height: u16,
};

const Image = struct {
    fmt: ImageFmt,
    data: *u8,
};

fn tracePath(comptime bgColor: Color, scene: *Scene, ray: Ray, depth: usize, maxDepth: usize) Color {
    if (depth >= maxDepth) {
        return bgColor; // Bounced enough times
    }
    scene.findNearestObject(&ray);
    if (ray.hit == null) {
        return bgColor; // Nothing was hit.
    }
    const target = ray.hit.?;
    const material = target.material;
    const emittance = material.emittance;
    // Pick a random direction from here and keep going.
    const newRay = Ray{ .origin = ray.pointWhereObjWasHit };
    // This is NOT a cosine-weighted distribution!
    newRay.direction = scene.randomUnitVectorInHemisphereOf(ray.normal);
    // Probability of the newRay
    const p = 1 / (2 * zm.PI);
    // Compute the BRDF for this ray (assuming Lambertian reflection)
    const cos_theta = zm.dot(newRay.direction, ray.normalWhereObjWasHit);
    const BRDF = material.reflectance / zm.PI;
    // Recursively trace reflected light sources.
    const incoming = tracePath(bgColor, newRay, depth + 1, maxDepth);
    // Apply the Rendering Equation here.
    return emittance + (BRDF * incoming * cos_theta / p);
}

fn render(fmt: ImageFmt, scene: Scene, numSamples: usize, maxDepth: usize) Image {
    const output = Image{
        .fmt = fmt,
        .data = zm.ArrayList(u8){},
    };
    for (output) |pixel| {
        for (numSamples) |_| {
            const r = scene.generateRay(pixel);
            pixel.color += tracePath(r, 0, maxDepth);
        }
        pixel.color /= numSamples; // Average samples.
    }
    return output;
}

pub fn main() !void {
    //const s = Box.State{
    //    .width = 1000,
    //    .height = 1000,
    //    .length = 1000,
    //};
}
