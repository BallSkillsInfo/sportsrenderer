const std = @import("std");

const Abdomen = packed struct {};
const Arm = packed struct {};
const Chest = packed struct {};
const Foot = packed struct {};
const Hand = packed struct {};
const Head = packed struct {};
const Leg = packed struct {};
const LowerBack = packed struct {};
const Neck = packed struct {};
const UpperBack = packed struct {};

const Body = packed struct {
    abdomen: Abdomen,
    arm: Arm,
    chest: Chest,
    foot: Foot,
    hand: Hand,
    head: Head,
    leg: Leg,
    lower_back: LowerBack,
    neck: Neck,
    upper_back: UpperBack,
};
