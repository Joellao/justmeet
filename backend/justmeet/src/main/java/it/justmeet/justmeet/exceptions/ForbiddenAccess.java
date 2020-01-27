package it.justmeet.justmeet.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.FORBIDDEN)
public class ForbiddenAccess extends RuntimeException {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    public ForbiddenAccess() {
        super();
    }

    public ForbiddenAccess(String errorMessage) {
        super(errorMessage);
    }
}