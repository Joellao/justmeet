package it.justmeet.justmeet.models.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import it.justmeet.justmeet.models.AbstractUser;

@Repository
public interface UserRepository extends JpaRepository<AbstractUser, Long> {
    AbstractUser findByUid(String uid);
   
}