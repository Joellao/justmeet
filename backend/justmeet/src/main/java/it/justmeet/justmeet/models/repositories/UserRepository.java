package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.UserInterface;

@Repository
<<<<<<< HEAD
public interface UserRepository extends JpaRepository<AbstractUser, Long> {
    AbstractUser findByUid(String uid);
=======
public interface UserRepository extends JpaRepository<UserInterface, Long> {
    UserInterface findByUid(String uid);
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
}