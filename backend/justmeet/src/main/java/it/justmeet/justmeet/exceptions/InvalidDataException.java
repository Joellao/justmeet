package it.justmeet.justmeet.exceptions;

public class InvalidDataException extends Exception {
	private static final long serialVersionUID = 1L;

    public InvalidDataException() {
        super();
    }

    public InvalidDataException(String errorMessage) {
        super(errorMessage);
    }

}
