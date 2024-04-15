extends Node

var Head = [
    "res://Textures/Heads/Head.png",
    "res://Textures/Heads/HeadBlack.png",
    "res://Textures/Heads/HeadGreen.png",
    "res://Textures/Heads/HeadKnight.png",
    "res://Textures/Heads/HeadRed.png",
    "res://Textures/Heads/HeadGreen.png",
    "res://Textures/Heads/Bald.png",
    "res://Textures/Heads/BaldHair.png",
    "res://Textures/Heads/HeadFur.png",
    "res://Textures/Heads/HeadFur2.png",
    "res://Textures/Heads/WhiteHood.png",
]

var Body = [
    "res://Textures/Bodies/Body.png",
    "res://Textures/Bodies/BodyFur.png",
    "res://Textures/Bodies/BodyFur2.png",
    "res://Textures/Bodies/BodyGreen.png",
    "res://Textures/Bodies/BodyKnight.png",
    "res://Textures/Bodies/BodyPig.png",
    "res://Textures/Bodies/BodyRed.png",
    "res://Textures/Bodies/BodyWhite.png",
    "res://Textures/Bodies/BodyWhiteRobe.png",
]

var Wand = [
    "res://Textures/Wands/Wand.png",
    "res://Textures/Wands/Book.png",
    "res://Textures/Wands/Sword.png",
    "res://Textures/Wands/Teddy.png",
]

var Undead = {
    "Head": [
        "res://Textures/Heads/UndeadHead.png",
        "res://Textures/Heads/UndeadMohawk.png",
        "res://Textures/Heads/UndeadSkeleton.png",
        "res://Textures/Heads/UndeadCloaked.png",
        "res://Textures/Heads/UndeadBlueMan.png",
        "res://Textures/Heads/NoHead.png",
    ],
    "Body": [
        "res://Textures/Bodies/UndeadBody.png",
        "res://Textures/Bodies/UndeadSkeleton.png",
        "res://Textures/Bodies/UndeadBlueBody.png",
        "res://Textures/Bodies/UndeadCloak.png",
    ],
    "Wand": [
        "res://Textures/Wands/NoWand.png",
        "res://Textures/Wands/Claws.png",
        "res://Textures/Wands/Fingers.png",
        "res://Textures/Wands/Gun.png",
    ],
}

const PARTS = ["Head", "Body", "Wand"]

func _ready():
    load_all()

var loaded = false
func load_all():
    if !loaded:
        loaded = true

        for x in Parts.PARTS:
            for i in range(Parts[x].size()):
                Parts[x][i] = load(Parts[x][i])

        for x in Parts.PARTS:
            for i in range(Parts.Undead[x].size()):
                Parts.Undead[x][i] = load(Parts.Undead[x][i])

        return true
    else:
        return false