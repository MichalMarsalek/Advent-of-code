from copy import deepcopy
import random
from time import time

tstart = time()

class Spell:
    def __init__(self, name, cost, timer, damage, healing=0, armor=0, recharge=0):
        self.name = name
        self.cost = cost
        self.timer = timer
        self.damage = damage
        self.healing = healing
        self.armor = armor
        self.recharge = recharge
    def apply(self, player):
        player.mana += self.recharge
        player.health += self.healing
        player.armor += self.armor
        if self.damage:
            player.targ.get_attacked(self.damage)
    def __str__(self):
        parts = []
        for name, value in [("deals %s damage", self.damage), ("heals %s hit points", self.healing), ("increases armor by %s", self.armor), ("provides %s", self.recharge)]:
            if value == 0:
                continue
            parts.append(name % (value,))
        return self.name + " " + ", ".join(parts)
    def __hash__(self):
        return hash(self.name)
    def __eq__(self, other):
        return self.name == other.name

class Warrior:
    def __init__(self, name, health, mana, *spells):
        self.name = name
        self.health = health
        self.mana = mana
        self.spent = 0
        self.armor = 0
        self.spells = spells
        self.effects = {}
    def target(self, warrior):
        self.targ = warrior
    def cast(self, spell):
        self.mana -= spell.cost
        self.spent += spell.cost
        if spell.timer == 0:
            spell.apply(self)
            return "%s casts %s (- %s mana)" % (self.name, spell, spell.cost)
        else:
            self.effects[spell] = spell.timer
            return "%s casts %s (- %s mana)" % (self.name, spell.name, spell.cost)
    def do_effects(self):
        self.armor = 0
        output = ""
        for effect in self.effects:
            if self.effects[effect] == 0:
                continue
            effect.apply(self)
            self.effects[effect] -= 1
            output += " - %s; its timer is now %s\n" % (effect, self.effects[effect])
        return output
    def aval_spells(self, min_spent):
        return [spell for spell in self.spells
            if spell.cost <= self.mana
            and self.effects.get(spell, 0) == 0
            and self.spent + spell.cost <= min_spent]
        return aval
    def get_attacked(self, damage):
        hit = max(1, damage - self.armor)
        self.health -= hit
    def is_alive(self):
        return self.health > 0
    def __str__(self):
        return "%s has %s hit points, %s armor, %s mana and spent %s mana" % (self.name, self.health, self.armor, self.mana, self.spent)

def solve(input):
    missile = Spell("Missile", 53, 0, 4)
    drain = Spell("Drain", 73, 0, 2, 2)
    shield = Spell("Shield", 113, 6, 0, 0, 7)
    poison = Spell("Poison", 173, 6, 3)
    recharge = Spell("Recharge", 229, 5, 0, 0, 0, 101)
    player = Warrior("Michal", 50, 500, missile, drain, shield, poison, recharge)
    
    boss_health, boss_damage = input.replace("Hit Points: ", "").replace("Damage: ", "").split("\n")
    damage_spell = Spell("Damage", 0, 0, int(boss_damage))
    enemy = Warrior("Boss", int(boss_health), 0, damage_spell)
    
    part1 = 0
    #wins_costs = [1000]
    #logs = fight(wins_costs, player, enemy)
    #part1 = min(wins_costs)
    wins_costs = [2000]
    logs = fight(wins_costs, player, enemy, 1)
    part2 = min(wins_costs)
    return part1, part2

def fight(wins_costs, player, enemy, difficulty = 0):
    player, enemy = clone_wars(player, enemy)
    output = """
    
    -- %s turn -- 
     - %s
     - %s
     """ % (player.name, player, enemy)
    output += player.do_effects()
    output += enemy.do_effects()
    if player.name == "Michal":
        player.health -= difficulty
    if not player.is_alive():
        return [output + dead(player, enemy, wins_costs)]
    logs = []
    aval_spells = player.aval_spells(min(wins_costs) if wins_costs else 999999999999)
    can_cast = ["%s (%s)" % (s.name, s.cost) for s in aval_spells]
    if can_cast:
        output += "\nHe can cast " + ", ".join(can_cast) + " as he has %s mana" % player.mana
    if not aval_spells:
        return [output + "\n     " + dead(player, enemy, wins_costs)]
    for spell in aval_spells:
        if player.name == "Michal" and player.spent == 0:
            start = time()
        if player.name == "Michal" and player.spent >= (max(wins_costs) if wins_costs else 0):
            print(player.spent)
        subplayer, subenemy = clone_wars(player, enemy)
        output1 = subplayer.cast(spell)
        if subenemy.is_alive():
            sublogs = fight(wins_costs, subenemy, subplayer, difficulty)
            for sublog in sublogs:
                logs.append(output + "\n      " + output1 + sublog)
        else:
            logs.append(output + output1 + dead(subenemy, subplayer, wins_costs))
        if player.name == "Michal" and player.spent == 0:
            print(spell.name, time() - start)
    return logs

def clone_wars(a, b):
    a = deepcopy(a)
    b = deepcopy(b)
    a.target(b)
    b.target(a)
    return a, b

def dead(player, enemy, wins_costs):
    if player.name == "Boss":
        wins_costs.append(enemy.spent)
    return """
    !! %s is dead !!
    -----------------------------------------------------------------------------------------------""" % (player.name)

def run(day):
    input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(22)

print(time() - tstart)
