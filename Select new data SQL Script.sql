-- Выборка альбомов, выпущенных в 2018 году
SELECT
	title "Название альбома",
	release_year  "Год выпуска"
FROM
	album_1 a 
WHERE 
	release_year  = 2018
-- за 2018-й год в базе нет альбомов
ORDER BY
	title ;

-- Выборка названия и продолжительности самого длинного трека
SELECT
	name "Название трека",
	concat((length/60)::TEXT,':',(length - (length/60)*60)::TEXT) "Длительность"
FROM
	track_1 t 
WHERE 
	length = (SELECT max(length) FROM track_1);

-- Выборка треков длительностью не менее 3,5 минуты
SELECT
	name "Название трека",
	concat((length/60)::TEXT,':',(length - (length/60)*60)::TEXT) "Длительность"
FROM
	track_1 t 
WHERE 
	length >= (3.5 * 60)
ORDER BY
	length DESC ;

-- Выборка сборников, выпущенных в период с 2018 по 2020 год включительно
SELECT
	title  "Название сборника",
	release_year  "Дата выпуска"
FROM
	collection_1 c 
WHERE 
	release_year BETWEEN 2018 AND 2020 
ORDER BY
	release_year ;

-- Выборка исполнителей, чье имя состоит из одного слова
-- Поскольку в базе данных есть поля имени, фамилии и псевдонима(названия группы),
-- то имена, состоящие из нескольких слов могут быть только в поле псевдонима
-- но выборка по условиям сделана для всех полей
SELECT
	first_name "Имя",
	second_name "Фамилия",
	alias "Псевдоним/Название группы"
FROM
	artist_1 a 
WHERE 
	(length(first_name) > 0 AND first_name NOT LIKE '% %' AND length(second_name) = 0 AND length(alias) = 0) OR 
	(length(second_name) > 0 AND second_name  NOT LIKE '% %' AND length(first_name) = 0 AND length(alias) = 0) OR 
	(length(alias) > 0 AND alias NOT LIKE '% %' AND length(first_name) = 0 AND length(second_name) = 0)	
	
	;

-- Выборка треков, названия которых содержат слово "мой" или "my"
SELECT
	name "Название"
FROM
	track_1
WHERE 
	lower(name) LIKE '%мой%' OR 
	lower(name) LIKE '%my%'
	;


