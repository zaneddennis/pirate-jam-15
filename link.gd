extends Node


# this is super super hacky, but it's a game jam so screw it
@onready var game = get_tree().root.get_node("Game")
@onready var player = game.get_node("Player")
@onready var ui = game.get_node("UI")
@onready var world = game.get_node("World")
