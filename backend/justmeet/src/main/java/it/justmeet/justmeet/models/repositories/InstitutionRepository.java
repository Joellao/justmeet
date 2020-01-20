package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.Institution;

@Repository
public interface InstitutionRepository extends JpaRepository<Institution, Long> {
    Institution findByUid(String uid);

}