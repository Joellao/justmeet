package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.Announcement;

@Repository
public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {
}