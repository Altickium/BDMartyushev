CREATE SCHEMA martyushev_project;

SET SEARCH_PATH = martyushev_project;

-- Созадем таблицы. Пункт 1. --

DROP TABLE IF EXISTS PLAYER_PROFILE CASCADE;
CREATE TABLE PLAYER_PROFILE (
    player_id INTEGER PRIMARY KEY,
    balance REAL CHECK ( balance >= 0 ),
    friend_count INTEGER,
    inventory_id INTEGER
);

DROP TABLE IF EXISTS INVENTORY CASCADE;
CREATE TABLE INVENTORY (
    inventory_id INTEGER PRIMARY KEY,
    item_count INTEGER,
    player_id INTEGER
);

ALTER TABLE INVENTORY ADD CONSTRAINT I_player_id
FOREIGN KEY (player_id) REFERENCES player_profile(player_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE PLAYER_PROFILE ADD CONSTRAINT PP_inventoryId
FOREIGN KEY (inventory_id) REFERENCES INVENTORY(inventory_id) ;

DROP TABLE IF EXISTS ITEM CASCADE;
CREATE TABLE ITEM (
    item_id INTEGER PRIMARY KEY,
    hero_name TEXT,
    inventory_id INTEGER,
    rarity TEXT NOT NULL default 'Common',
    body_part TEXT NOT NULL ,
    description_item TEXT,
    model_item TEXT NOT NULL
);

DROP TABLE IF EXISTS HERO CASCADE;
CREATE TABLE HERO (
    hero_name TEXT PRIMARY KEY,
    lore TEXT NOT NULL UNIQUE,
    release_date_hero DATE NOT NULL DEFAULT now()::date,
    model_hero TEXT NOT NULL,
    leg_count INTEGER CHECK ( leg_count >= 0 )
);

DROP TABLE IF EXISTS ABILITY CASCADE;
CREATE TABLE ABILITY (
    ability_name TEXT PRIMARY KEY,
    manacost INTEGER NOT NULL DEFAULT 0,
    cooldown REAL NOT NULL DEFAULT 0.0,
    description_ability TEXT NOT NULL,
    cast_time REAL CHECK ( cast_time >= 0 ),
    release_date_ability DATE NOT NULL DEFAULT now()::date
);

DROP TABLE IF EXISTS ABILITY_HISTORIC CASCADE;
CREATE TABLE ABILITY_HISTORIC (
    ability_name TEXT NOT NULL,
    change_date DATE NOT NULL,
    manacost INTEGER NOT NULL DEFAULT 0,
    cooldown REAL NOT NULL DEFAULT 0.0,
    description_ability TEXT NOT NULL,
    cast_time REAL CHECK ( cast_time >= 0 ),
    release_date_ability DATE NOT NULL DEFAULT now()::date,
    CONSTRAINT PK_date_name PRIMARY KEY (ability_name, change_date)
);

DROP TABLE IF EXISTS MATCH CASCADE;
CREATE TABLE MATCH (
    match_id integer PRIMARY KEY,
    duration INTEGER,
    dire_won BOOLEAN
);

ALTER TABLE ITEM ADD CONSTRAINT IT_hero_name
FOREIGN KEY (hero_name) REFERENCES HERO(hero_name)
    ON UPDATE RESTRICT ;

ALTER TABLE ITEM ADD CONSTRAINT IT_inventory_id
FOREIGN KEY (inventory_id) REFERENCES INVENTORY(inventory_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

DROP TABLE IF EXISTS ITEM_X_ABILITY CASCADE;
CREATE TABLE ITEM_X_ABILITY (
    IA_item_id integer not null,
    IA_ability_name TEXT not null,
    CONSTRAINT PK_name_id PRIMARY KEY (IA_ability_name, IA_item_id),
    CONSTRAINT FK_name_id_1 FOREIGN KEY (IA_ability_name) references ABILITY(ability_name),
    CONSTRAINT FK_name_id_2 FOREIGN KEY (IA_item_id) references ITEM(item_id)
);

DROP TABLE IF EXISTS ABILITY_X_HERO CASCADE;
CREATE TABLE ABILITY_X_HERO (
    AH_hero_name TEXT not null,
    AH_ability_name TEXT not null,
    CONSTRAINT PK_ability_hero PRIMARY KEY (AH_ability_name, AH_hero_name),
    CONSTRAINT FK_ability_hero_1 FOREIGN KEY (AH_hero_name) references HERO(hero_name),
    CONSTRAINT FK_ability_hero_2 FOREIGN KEY (AH_ability_name) references ABILITY(ability_name)
);

DROP TABLE IF EXISTS HERO_X_PLAYER_X_MATCH_INFO CASCADE;
CREATE TABLE HERO_X_PLAYER_X_MATCH_INFO (
    HPM_hero_name TEXT not null,
    HPM_player_id INTEGER not null,
    HPM_match_id INTEGER not null,
    CONSTRAINT PK_hero_player_match PRIMARY KEY (HPM_hero_name, HPM_match_id, HPM_player_id),
    CONSTRAINT FK_hpm_1 FOREIGN KEY (HPM_match_id) references match(match_id),
    CONSTRAINT FK_hpm_2 FOREIGN KEY (HPM_player_id) references player_profile(player_id),
    CONSTRAINT FK_hpm_3 FOREIGN KEY (HPM_hero_name) references HERO(hero_name)
);

-- Заполняем таблицы. Пункт 2 --

--Заполняем таблицу hero--
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Pudge', 'На полях Вечной бойни, далеко на юге от Квойджа, тучная фигура упорно трудится под покровом ночи', CAST ('2011-07-09' as date), 'common/textures/pudge', 2);
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Io', 'Ио — непостижимое проявление жизненной силы, присутствующее везде и во всём', CAST ('2011-07-09' as date), 'common/textures/IO', 0);
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Shadow Fiend', 'Говорят, у Невермора душа поэта, но на самом деле у него их тысячи.', CAST ('2011-07-09' as date), 'common/textures/shadowfiend', 0);
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Spirit Breaker', 'Баратрум — гордое и могущественное существо, яростный первичный разум.', CAST ('2011-07-09' as date), 'common/textures/spiritbreaker', 2);
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Abaddon', 'Род Аверно питает купель — разлом в земной тверди, который испускает загадочную энергию на протяжении поколений.', CAST ('2013-07-12' as date), 'common/textures/Hoodwink', 4);

--заполняем таблицу player_profile--
INSERT INTO player_profile(player_id) VALUES (1);
INSERT INTO player_profile(player_id) VALUES (2);
INSERT INTO player_profile(player_id) VALUES (3);
INSERT INTO player_profile(player_id) VALUES (4);
INSERT INTO player_profile(player_id) VALUES (5);
INSERT INTO player_profile(player_id) VALUES (6);

--заполняем таблицу inventory--
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(1, 12, 1);
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(2, 0, 2);
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(4, 100,4);
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(5, 10,5);
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(33, 467, 3);
INSERT INTO inventory(inventory_id, item_count, player_id) VALUES(117, 671, 6);

UPDATE player_profile SET balance = 10.0, friend_count = 2, inventory_id = 1 WHERE player_id = 1;
UPDATE player_profile SET balance = 0.0, friend_count = 20, inventory_id = 2 WHERE player_id = 2;
UPDATE player_profile SET balance = 15.0, friend_count = 0, inventory_id = 33 WHERE player_id = 3;
UPDATE player_profile SET balance = 60.0, friend_count = 140, inventory_id = 4 WHERE player_id = 4;
UPDATE player_profile SET balance = 25.0, friend_count = 1, inventory_id = 5 WHERE player_id = 5;
UPDATE player_profile SET balance = 100.4, friend_count = 17, inventory_id = 117 WHERE player_id = 6;

--заполняем таблицу item--
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(1, 'Pudge', 1, 'Arcana', 'Torso', 'Много веков назад мифическая волшебница Крелла сковала нерушимый крюк на цепи', 'common/textures/feastofabscession');
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(2, 'Pudge', 1, 'Immortal', 'Right Hand', 'Почему это сочные кишочки должны украшать лишь подбородок?', 'common/textures/abscesserator');
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(3, 'Abaddon', 2, 'Rare', 'Mount', '', 'common/textures/nightsbane');
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(4, 'Spirit Breaker', 33, 'Immortal', 'Weapon', 'Цеп Баратрума, скованный вокруг ядра из сжатой энергии элементов, способен пересекать границы между мирами.', 'common/textures/savagemettle');
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(178, 'Shadow Fiend', 117, 'Mythic', 'Shoulder', '', 'common/textures/eternalharvest_pauldrons');

--Заполняем таблицу ability--
INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Meat Hook', 110, 12, 'Крюк мясника — это воплощение кошмара: его изогнутое лезвие всем своим видом требует крови.', 0.8, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, description_ability, cast_time, release_date_ability) VALUES('Rot', 'Чувствуете удушающий запах гнили? Это ядовитый газ, что источает прелая пухнущая плоть мясника.', 0.0, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Flesh Heap',80, 17, 'Мясник не понаслышке знает, каково это — быть толстокожим.', 0.0, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Dismember', 170, 20, '«Есть с падалью одна загвоздка: час как поел — и опять голодный!»', 0.3, CAST ('2011-07-09' as date));

INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Charge of Darkness', 100, 11, 'Баратрум прорывается сквозь тьму с неудержимой силой.', 0.0, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, description_ability, cast_time, release_date_ability) VALUES('Greater Bash', 'Фирменный удар призрачного цепа Баратрума.', 0.3, CAST ('2011-07-09' as date));

INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Shadowraze', 90, 10, 'Фирменный метод сбора душ.', 0.55, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Requiem of Souls', 200, 100, 'Заточённые души тех, кто пал в былых сражениях, обретают свободу, дабы мстительно преследовать своих бывших союзников.', 1.67, CAST ('2011-07-09' as date));

INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Aphotic Shield', 130, 6, 'Сила чёрного тумана поглощает удары так же, как он сам поглощает дневной свет.', 0.63, CAST ('2013-07-12' as date));
INSERT INTO ability(ability_name, cooldown, description_ability, cast_time, release_date_ability) VALUES('Borrowed Time', 40, 'Эта сила, самая противоестественная из всех даров купели Аверно, бросает вызов пониманию смертных. Что должно ранить — лечит, а что должно убить — даёт свежие силы.', 0.0, CAST ('2013-07-12' as date));

INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Spirits', 130, 20,  'Своей невообразимой силой предвечный раскручивает частицы вселенной.', 0.0, CAST ('2011-07-09' as date));
INSERT INTO ability(ability_name, manacost, cooldown, description_ability, cast_time, release_date_ability) VALUES('Relocate', 175, 80, 'Ио есть воплощение тайн вселенной.', 0.0, CAST ('2011-07-09' as date));

--Заполняем таблицу item_x_ability--
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (1, 'Meat Hook');
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (1, 'Rot');
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (1, 'Flesh Heap');
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (1, 'Dismember');
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (2, 'Meat Hook');
INSERT INTO ITEM_X_ABILITY(IA_item_id, IA_ability_name) VALUES (4, 'Greater Bash');

--Заполяем таблицу ability_x_hero--
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Abaddon', 'Aphotic Shield');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Abaddon', 'Borrowed Time');

INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Shadow Fiend', 'Shadowraze');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Shadow Fiend', 'Requiem of Souls');

INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Spirit Breaker', 'Charge of Darkness');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Spirit Breaker', 'Greater Bash');

INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Io', 'Spirits');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Io', 'Relocate');

INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Pudge', 'Meat Hook');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Pudge', 'Rot');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Pudge', 'Flesh Heap');
INSERT INTO ABILITY_X_HERO(ah_hero_name, ah_ability_name) VALUES ('Pudge', 'Dismember');

--Запонляем таблицу match--
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (1, 40, true);
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (2, null, null);
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (4, 15, true);
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (5, 20, true);
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (100, 120, false);
INSERT INTO MATCH(match_id, duration, dire_won) VALUES (130, 70, false);

--Заполняем таблицу hero_x_player_x_match
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Abaddon', 1, 1);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Pudge', 2, 5);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Shadow Fiend', 3, 100);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Io', 4, 4);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Spirit Breaker', 5, 2);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Pudge', 2, 100);
INSERT INTO HERO_X_PLAYER_X_MATCH_INFO(hpm_hero_name, hpm_player_id, hpm_match_id) VALUES ('Abaddon', 4, 2);

--Заполняем таблицу Abiltiy_Historic--
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Meat Hook', CAST ('2016-08-12' as date), 15, 100, 'Крюк мясника — это воплощение кошмара: его изогнутое лезвие всем своим видом требует крови.', 0.8, CAST ('2011-07-09' as date));
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Meat Hook', CAST ('2018-08-12' as date), 13, 100, 'Крюк мясника — это воплощение кошмара: его изогнутое лезвие всем своим видом требует крови.', 0.8, CAST ('2011-07-09' as date));
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Meat Hook', CAST ('2021-01-27' as date), 12, 110, 'Крюк мясника — это воплощение кошмара: его изогнутое лезвие всем своим видом требует крови.', 1.1, CAST ('2011-07-09' as date));
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Flesh Heap', CAST ('2021-01-27' as date),  0, 0, 'Мясник не понаслышке знает, каково это — быть толстокожим.', 0.0, CAST ('2011-07-09' as date));
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Borrowed Time', CAST ('2021-01-27' as date), 0, 50, 'Эта сила, самая противоестественная из всех даров купели Аверно, бросает вызов пониманию смертных. Что должно ранить — лечит, а что должно убить — даёт свежие силы.', 0.0, CAST ('2013-07-12' as date));
INSERT INTO ABILITY_HISTORIC(ABILITY_NAME, CHANGE_DATE, MANACOST, COOLDOWN, DESCRIPTION_ABILITY, CAST_TIME, RELEASE_DATE_ABILITY) VALUES ('Requiem of Souls', CAST ('2020-10-01' as date), 100, 200, 'Заточённые души тех, кто пал в былых сражениях, обретают свободу, дабы мстительно преследовать своих бывших союзников.', 1.67, CAST ('2011-07-09' as date));

-- 3 --
INSERT INTO hero(hero_name, lore, release_date_hero, model_hero, leg_count) VALUES('Ursa', 'Воин Ульфсаар — сильнейший член медвежьего племени, стоящий горой за свои земли и свой народ.', CAST ('2011-07-09' as date), 'common/textures/ursa', 2);

--Сначала напишем CRUD для item, потом вернемся к hero
INSERT INTO item(item_id, hero_name, inventory_id, rarity, body_part, description_item, model_item) VALUES(227, 'Ursa', 1, 'Uncommon', 'Head', '', 'common/textures/alpinestalkerhead');

SELECT
    *
FROM ITEM
WHERE inventory_id = 1;

UPDATE ITEM
    SET rarity = 'Immortal'
where item_id = 227;

DELETE FROM ITEM WHERE item_id = 227;

--Допишем для hero--

SELECT *
FROM HERO
WHERE leg_count > 0;

UPDATE HERO
    SET model_hero = 'common/textures/Io'
WHERE model_hero = 'common/textures/IO';

DELETE FROM HERO WHERE hero_name = 'Ursa';

-- 4 --
-- a) Найдем id инвентарей, в которых есть вещи высокого качества (Immortal или Arcana)
SELECT
    inventory_id
from
    ITEM
where rarity in ('Arcana', 'Immortal');
-- В результате работы получим инвентари, скорее всего, их будет не так много т.к. предметы высокого качества.

-- b) Хотим посчитать среднюю длительность матчей, в которых победила сторона Тьма и в которых победила сторона Света. При чем не учитываем несостоявшиеся матчи (т.е. где dire_won = null)
SELECT
    avg(duration),
    dire_won
FROM MATCH
GROUP BY dire_won
HAVING dire_won is not null;

-- В результате работы сможем узнать в среднем насколько сложнее выиграть за сторону Тьмы/Света (посмотрев на разности в длине матчей)

-- c) Хотим узнать для каждого игрока, на каких героях и сколько раз он играл.

SELECT DISTINCT
    player_id,
    HPM_hero_name,
    count(HPM_hero_name) over (partition by player_id, HPM_hero_name order by player_id asc) as times_played
from PLAYER_PROFILE p
INNER JOIN HERO_X_PLAYER_X_MATCH_INFO hpm
on HPM_player_id = p.player_id
order by player_id, times_played asc;
-- В результате работы получим табличку, в которой будет указано, на каких героях чаще всего играл тот или иной человек.

-- d) Хотим узнать, способности какого героя больше всего менялись.

select
    AH_hero_name,
    sum(times_changed) as number_of_patches
from ability_x_hero ah
INNER JOIN (SELECT
    ability_name,
    count(ability_name) as times_changed
FROM
    ability_historic
group by ability_name) as abilities_sumed
on AH_ability_name = ability_name
GROUP BY AH_hero_name
order by number_of_patches desc
limit 1;

--В результате работы получим имя героя и то, сколько раз его способности изменяли.

-- e) Хотим узнать средний расход маны героя на способность

SELECT
    hero_name,
    avg(manacost)
from hero
inner join ABILITY_X_HERO AXH on HERO.hero_name = AXH.AH_hero_name
inner join ABILITY A on A.ability_name = AXH.AH_ability_name
group by hero_name;

-- В результате запроса узнаем, каким героям нужно будет повысить/понизить цену на способности в зависимости от главного атрибута героя

