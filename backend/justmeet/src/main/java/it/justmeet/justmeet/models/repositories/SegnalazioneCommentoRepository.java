package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.SegnalazioneCommento;

@Repository
public interface SegnalazioneCommentoRepository extends JpaRepository<SegnalazioneCommento, Long> {
}