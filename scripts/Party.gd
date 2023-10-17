extends Node2D

var party_members : Array[PartyMember] = []

func _ready():
	party_members = []
	for c in get_children():
		if c is PartyMember:
			party_members.append(c)
			c.id = party_members.find(c)
	PartyController.party = party_members
