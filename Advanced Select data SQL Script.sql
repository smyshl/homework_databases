-- Продвинутая выборка данных

-- 1. Количество исполнителей в каждом жанре

    SELECT g_1."name" "Жанр",
           count(artist_id) "Количество исполнителей"
      FROM artists_genres AS ag
      JOIN genre_1 AS g_1
        ON g_1.id = genre_id
  GROUP BY g_1."name"  
  ORDER BY count(artist_id) DESC ;
 

 -- 2. Количество треков, вошедших в альбомы 2019-2020 годов
 
    SELECT a_1.release_year "Год выпуска альбомов",
           count(t_1.id) "Количество треков в альбомах"
      FROM album_1 AS a_1
      JOIN track_1 AS t_1
        ON t_1.album_id = a_1.id
     WHERE a_1.release_year BETWEEN 2019 AND 2020        
  GROUP BY a_1.release_year ;

 
 -- 3. Средняя продолжительность треков по каждому альбому
 
    SELECT a_1.title "Альбом",
           concat(((sum(t_1.length)/count(t_1.id))/60)::TEXT,':',((sum(t_1.length)/count(t_1.id)) - ((sum(t_1.length)/count(t_1.id))/60)*60)::TEXT) "Средняя продолжительность трека"
      FROM track_1 AS t_1
      JOIN album_1 AS a_1
        ON a_1.id = t_1.album_id 
  GROUP BY a_1.title 
  ORDER BY a_1.title;
 
 
-- 4. Все исполнители, которые не выпустили альбомы в 2020 году
  
    SELECT art_1.first_name || ' ' || art_1.second_name "Имя, фамилия",
           art_1.alias "Псевдоним/группа"
      FROM artist_1 AS art_1
      JOIN albums_artists AS a_a 
        ON a_a.artist_id = art_1.id 
      JOIN album_1 AS a_1
        ON a_1.id = a_a.album_id 
     WHERE a_1.release_year != 2020;
 
 -- 5. Названия сборников, в которых присутствует конкретный исполнитель
 --    Пусть это будет "НА-НА"
    
    UPDATE track_1 -- Надо добавить принадлежность к альбомам для некоторых треков
       SET album_id = 5
     WHERE id BETWEEN 38 AND 42;
    
    SELECT c_1.title "Название сборника"
      FROM collection_1 AS c_1
      JOIN collections_tracks AS c_t 
        ON c_t.collection_id = c_1.id 
     WHERE c_t.track_id IN 
     		(SELECT t_1.id 
     		   FROM track_1 AS t_1
     		   JOIN albums_artists AS a_a
     		     ON a_a.album_id = t_1.album_id
     		   JOIN artist_1 AS a_1
     		     ON a_1.id = a_a.artist_id
     		  WHERE a_1.alias = 'НА-НА')
  GROUP BY c_1.title ;
    
    
 -- 6. Названия альбомов, в которых присутствуют исполнители более 1 жанра
 
    SELECT a_1.title "Название альбома"
      FROM albums_artists AS a_a
      JOIN album_1 AS a_1
        ON a_1.id = a_a.album_id
     WHERE a_a.artist_id IN  
           (SELECT a_g.artist_id
              FROM artists_genres AS a_g
          GROUP BY a_g.artist_id  
            HAVING count(a_g.genre_id) > 1);
 
 
-- 7. Наименования треков, которые не входят в сборники
 
    SELECT t_1."name" "Название трека"
      FROM track_1 AS t_1
 LEFT JOIN collections_tracks AS c_t 
        ON c_t.track_id = t_1.id 
     WHERE c_t.track_id IS NULL ;
    
    
-- 8. Исполнитель(и), написавший(ие) самый короткий трек 
     
    SELECT a_1.first_name || ' ' || a_1.second_name "Имя, фамилия",
           a_1.alias "Псевдоним/группа"
      FROM artist_1 AS a_1
      JOIN albums_artists AS a_a 
        ON a_a.artist_id = a_1.id 
     WHERE a_a.album_id IN (
            SELECT t_1.album_id  
              FROM track_1 AS t_1
             WHERE t_1.length = (
                    SELECT min(t_1.length)
                      FROM track_1 AS t_1)) ;
        
 
-- 9. Название альбомов, содержащих наименьшее количество треков
                        
    SELECT a_1.title "Название альбома",
           count(t_1."name") "Количество треков"
      FROM album_1 AS a_1
      JOIN track_1 AS t_1
        ON t_1.album_id = a_1.id 
  GROUP BY a_1.title 
    HAVING count(t_1."name") <= ALL (
                      SELECT count(t_1."name") "Количество треков"
                        FROM album_1 AS a_1
                        JOIN track_1 AS t_1
                          ON t_1.album_id = a_1.id 
                    GROUP BY a_1.title);
           
 