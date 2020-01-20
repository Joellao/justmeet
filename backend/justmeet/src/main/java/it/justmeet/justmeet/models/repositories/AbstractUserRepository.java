package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.AbstractUser;

@Repository
public interface AbstractUserRepository extends JpaRepository<AbstractUser, Long> {
    AbstractUser findByUid(String uid);
}