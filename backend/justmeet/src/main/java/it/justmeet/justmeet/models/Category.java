package it.justmeet.justmeet.models;



public enum Category {
	CINEMA("Cinema"), 
	FIERE("Fiere"), 
	CONFERENZE("Conferenze"), 
	MOSTRE("Mostre"), 
	SPORT("Sport"), 
	MUSICA("Musica"), 
	SAGRE("Sagre"),
	TEATRO("Teatro"),
	FESTE("Feste");

	private final String name;

	/**
	 * Definisce le possibili categorie degli eventi
	 * 
	 * @param name è il nome del colore
	 * 
	 */
	Category(String name) {
		this.name = name;
	}

	/**
	 * definisco un array di categorie
	 */
	public static Category[] list = Category.values();

	/**
	 * Definisce la categoria associata all'indice
	 * 
	 * @param i indice della categoria
	 * @return categoria nella posizione i
	 */
	public static Category getCategory(int i) {
		return list[i];
	}

	/**
	 * Metodo che mi serve per sapere il nome della categoria
	 * 
	 * @return nome della categoria
	 */
	public String getName() {
		return name;
	}

}
