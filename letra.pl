cargarArchivo(Archivo,Lista):-
  seeing(Old),see(Archivo),read(Lista),seen,see(Old).
  
%%pertenece([],_). 
%%pertenece([H|T],Alfabeto):-
 %%member(H,Alfabeto),pertenece(T,Alfabeto).

vertical(par(F, C), par(NF, C)) :- NF is F+1.
horizontal(par(F, C), par(F, NC)) :- NC is C+1.
diagonal(P, NP) :- vertical(P,Inter),horizontal(Inter,NP).


buscarLetras(_, _, _, []).
buscarLetras(Direccion, M, Par, [H|T]):-
  buscarLetra(M,Par,H),
  call(Direccion, Par, NuevoPar),
  buscarLetras(Direccion, M, NuevoPar, T).

  
buscarLetra(matriz(_,Filas),par(F,C),Elem):-
    nth0(F,Filas,Fila),
    nth0(C,Fila,Elem).
  
desglosarPalabras(Palabra, Acumulador, [Caracteres|Acumulador]):-
    atom_chars(Palabra,Caracteres).

    
  
%filtroHorizontal(matriz(N,ListaLista),Palabra):-
  %atom_chars(Palabra,ListaPalabra),
  




sopaLetra(Tamano,ListaAceptados,ListaRechazados,Alfabeto,DesglosadosAceptados):-
  foldl(desglosarPalabras,ListaAceptados,[],DesglosadosAceptados).

chequearPalabra(Alfabeto,H):-
  atom_chars(H,Palabra), subset(Palabra,Alfabeto).

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
  %write(ListaAceptados),
  cargarArchivo(ArchivoRechazado,ListaRechazados),
  maplist(chequearPalabra(Alfabeto),ListaAceptados).
  %% pertenece(ListaAceptados,Alfabeto),
  %% pertenece(ListaRechazados,Alfabeto).
