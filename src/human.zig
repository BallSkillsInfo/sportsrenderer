const std = @import("std");

const Abdomen = packed struct {
    length: u8,
};
const Arm = packed struct {
    upperarm: UpperArm,
    forearm: ForeArm,
    length: u12, // centimetres, offset by 5
};
const Chest = packed struct {};
const Foot = packed struct {};
const ForeArm = packed struct {
    length: u6, // centimetres, offset by 5
};
const Hand = packed struct {};
const Head = packed struct {
    breadth: u8, // centimetres, offset by 1
    height: u8, // centimetres, offset by 1
    length: u8, // centimetres, offset by 1
    ear_breadth: u6, // millimetres, offset by 1
    upper_face_height: u10, // millimetres, offset by 1
    nose_height: u4, // millimetres, offset by 1
    morphological_face_height: u12, // millimetres, offset by 1
};
const Leg = packed struct {};
const LowerBack = packed struct {};
const Neck = packed struct {};
const UpperBack = packed struct {};
const UpperArm = packed struct {
    circumference_relaxed: u8, // centimetres
    circumference_contracted: u8, // centimetres
    length: u8, // centimetres
};

const Torso = packed struct {
    abdomen: Abdomen,
    chest: Chest,
    lower_back: LowerBack,
    upper_back: UpperBack,
    crown_rump_len: u8, // percentage
    proportion: u8, // fraction, offset by 1
};

const Limbs = packed struct {
    arm: Arm,
    foot: Foot,
    hand: Hand,
    leg: Leg,
    proportion: u8, // fraction, offset by 1
};

const Body = packed struct {
    head: Head,
    left_limbs: Limbs,
    neck: Neck,
    right_limbs: Limbs,
    torso: Torso,

    stature: u7, // centimetres, offset by 100, 100cm to 228cm
    weight: u18, // grams, offset by 1000, 1000g to 263144g(~263kg)
    lean_mass: u6, // percentage, offset by 24, 24% to 88%

    pub fn init() Body {
        return Body{ .head = {}, .left_limbs = {}, .neck = {}, .right_limbs = {}, .torso = {} };
    }
};
