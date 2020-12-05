class Item:
    def __init__(self, name, cost, damage, armor):
        self.name = name
        self.cost = cost
        self.damage = damage
        self.armor = armor

class Warrior:
    def __init__(self, name, health):
        self.name = name
        self.health = health
        self.spent = 0
        self.damage = 0
        self.armor = 0
    def buy(self, *items):
        self.spent += sum(i.cost for i in items)
        self.damage += sum(i.damage for i in items)
        self.armor += sum(i.armor for i in items)
    def target(self, warrior):
        self.targ = warrior
    def attack(self):
        self.targ.get_attacked(self.damage)
    def get_attacked(self, damage):
        hit = max(1, damage - self.armor)
        self.health -= hit
    def is_alive(self):
        return self.health > 0

def solve(input):
    weapons = [Item("Dagger", 8, 4, 0), Item("Shortsword", 10, 5, 0), Item("Warhammer", 25, 6, 0), Item("Longsword", 40, 7, 0), Item("Greataxe", 74, 8, 0)]
    armors = [Item("no a", 0, 0, 0), Item("Leather", 13, 0, 1), Item("Chainmail", 31, 0, 2), Item("Splintmail", 53, 0, 3), Item("Bandedmail", 75, 0, 4), Item("Platemail", 102, 0, 5)]
    rings = [Item("no r a", 0, 0, 0), Item("no r b", 0, 0, 0), Item("Damage +1", 25, 1, 0), Item("Damage +2", 50, 2, 0), Item("Damage +3", 100, 3, 0), Item("Defense +1", 20, 0, 1), Item("Defense +2", 40, 0, 2), Item("Defense +3", 80, 0, 3)]
    wins = []
    loses = []
    for weapon in weapons:
        for armor in armors:
            for i, ring1 in enumerate(rings[:-1]):
                for ring2 in rings[i:]:
                    enemy = get_enemy(input)
                    player = Warrior("Michal", 100)
                    player.buy(weapon, armor, ring1, ring2)
                    if fight(player, enemy):
                        wins.append(player.spent)
                    else:
                        loses.append(player.spent)
    part1 = min(wins)
    part2 = max(loses)
    return part1, part2

def fight(war1, war2):
    turn = war1
    war1.target(war2)
    war2.target(war1)
    while(war1.is_alive() and war2.is_alive()):
        turn.attack()
        turn = war1 if turn == war2 else war2
    return war1.is_alive()

def get_enemy(input):
    boss_health, boss_damage, boss_armor = input.replace("Hit Points: ", "").replace("Damage: ", "").replace("Armor: ", "").split("\n")
    enemy = Warrior("Boss", int(boss_health))
    enemy.buy(Item("Weapon", 0, int(boss_damage), 0), Item("Armor", 0, 0, int(boss_armor)))
    return enemy

def run(day):
    input = input = open('Day ' + str(day) + ' input.txt').read()
    print(solve(input))

run(21)
