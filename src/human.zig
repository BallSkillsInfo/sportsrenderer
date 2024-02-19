const std = @import("std");

const Abdomen = packed struct {
	
};
const Arm = packed struct {};
const Chest = packed struct {};
const Foot = packed struct {};
const Hand = packed struct {};
const Head = packed struct {};
const Leg = packed struct {};
const LowerBack = packed struct {};
const Neck = packed struct {};
const UpperBack = packed struct {};

const Torso = packed struct {
    abdomen: Abdomen,
    chest: Chest,
    lower_back: LowerBack,
    upper_back: UpperBack,
};

const Limbs = packed struct {
    arm: Arm,
    foot: Foot,
    hand: Hand,
    leg: Leg,
};

const Body = packed struct {
    head: Head,
    left_side: Limbs,
    neck: Neck,
    right_side: Limbs,
    torso: Torso,
};
