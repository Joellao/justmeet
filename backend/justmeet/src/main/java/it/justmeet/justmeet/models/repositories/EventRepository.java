package it.justmeet.justmeet.models.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.Event;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    @Query(value = "SELECT t.id FROM (SELECT id, (6371 * acos (cos ( radians(:lat) )* cos( radians( latitude ) )* cos( radians( longitude ) - radians(:lon) )+ sin ( radians(:lat) )* sin( radians( latitude ) ))) AS distance FROM events) t GROUP BY t.id, t.distance HAVING distance < :raggio ORDER BY distance", nativeQuery = true)
    List<Long> findByLatAndLon(@Param("lat") double lat, @Param("lon") double lon, @Param("raggio") int raggio);
}