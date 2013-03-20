recorrerListaHorizontal([], _, _).
recorrerListaHorizontal([H|T], M, par(F,C)):-
  buscarLetra(M,par(F,C),H),
  nuevoParH(par(F, C), NuevoPar),
  recorrerListaHorizontal(T, M, NuevoPar).
  
recorrerListaVertical([],_,_).
recorrerListaVertical([H|T],M,par(F,C)):-
  buscarLetra(M,par(F,C),H),
  ColumnaNueva is C+1,
  NuevoPar = par(F, ColumnaNueva),
  recorrerListaVertical(T, M, NuevoPar).
    
recorrerListaDiagonal([],_,_).
recorrerListaDiagonal([H|T],M,par(F,C)):-
  buscarLetra(M,par(F,C),H),
  ColumnaNueva is C+1,
  FilaNueva is F+1,
  NuevoPar = par(FilaNueva, ColumnaNueva),
  recorrerListaDiagonal(T, M, NuevoPar).

%% Implantacion del predicado: mostrarSopaAux(L).
%% Este predicado triunfa si se logra imprimir
%% por pantalla una lista.
mostrarSopaAux([]).
mostrarSopaAux([H|T]) :- write(H),tab(1),mostrarSopaAux(T).

%% Implantacion del predicado: mostrarSopa(L).
%% Este predicado triunfa si se logra imprimir
%% la sopa de letras por pantalla
mostrarSopa([]).
mostrarSopa([H|T]) :- mostrarSopaAux(H),nl,mostrarSopa(T).

%% Implantacion del predicado:perteneceAAlfabeto(Letra,Alfabeto).
%% Triunfa si la letra dada pertenece a la lista Alfabeto.
perteneceAAlfabeto(X,[X|_]).
pertneceAAlfabeto(X,[H|T]) :- 
    H =:= 91,
    perteneceAAlfabeto(X,T).
pertneceAAlfabeto(X,[H|T]) :-
    H =:= 93,
    perteneceAAlfabeto(X,T).
pertneceAAlfabeto(X,[H|T]) :-
    H =:= 44,
    perteneceAAlfabeto(X,T).
perteneceAAlfabeto(X,[H|T]) :- 
    H\==X,
    perteneceAAlfabeto(X,T).

%% Implantacion del predicado: pertenece(Lista,Alfabeto).
%% Este predicado triunfa si todas las letras de Lista
%% pertenece al Alfabeto.
pertenece([H|T],Alfabeto) :- 
    perteneceAAlfabeto(H,Alfabeto),
    pertenece(T,Alfabeto).

%% Implantacion del predicado: cargarListaPalabra(Alfabeto,Archivo).
cargarListaPalabra(Alfabeto,Archivo,ListaPalabras) :- 
    cargarArchivo(Archivo,Lista),
    pertenece(Lista,Alfabeto).
    %% transformar(Lista,ListaPalabras).

%% Implantacion del predicado: transformarAux(Lista,Palabra).
transformarAux([H1,H2|T],L):- 
    H1\==44,
    H1\==91,
    H1\==93,
    concat(H1,H2,L),
    transformarAux(T,L).
transformarAux([H1|T],L) :-
    H1=:=91,
    transformarAux(T,L).
transformarAux([H1|T],L) :-
    H1 =:=44.
transformarAux([H1|T],L) :-
    H1 =:= 93.
 

%% Implantacion del predicado: leerEnLista(?Lista) /1.
%% Este predicado triunfa cuando Lista es la lista de
%% palabras.
leerEnLista([Valor|RestoPorLeer]) :- 
    get(Valor),
    Valor\==(46), 
    leerEnLista(RestoPorLeer). 
leerEnLista([]):-
    get(Valor),
    Valor=:=(46).

imprimirLista([]).
imprimirLista([H|T]):- write(H), imprimirLista(T).

%% Implantacion del predicado: cargarArchivo(+Archivo,-Lista) /2
%% Este predicado triunfa cuando Lista es la lista que contiene
%% las palabras leidas de Archivo.
cargarArchivo(Archivo,Lista) :- see(Archivo),leerEnLista(Lista).


%% Implantacion del predicado: generadorSopa.
generadorSopa :-
        write('Introduzca el tamano de la sopa de letras a generar:'),
        read(Tamano),
        write('Introduzca el alfabeto de la sopa de letras:'),
        read(Alfabeto),
        write('Introduzca el archivo que contiene la lista de palabras a aceptar:'),
        read(ArchivoAceptado),
        write('Introduzca el archivo que contiene la lista de palabras a rechazar:'),
        read(ArchivoRechazado),
	   cargarArchivo(ArchivoAceptado,ListaAceptados),
        cargarArchivo(ArchivoRechazado,ListaRechazados),
        pertenece(ListaAceptados,Alfabeto),
        pertenece(ListaRechazados,Alfabeto),
	   seen.
