% De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se conoce el nombre y la cantidad de minutos de duración.

% a) Generar la base de conocimientos inicial

% cantante(Nombre,cancion(Cancion,Duracion)).
cantante(megurineLuka,cancion(nightFever,4)).
cantante(megurineLuka,cancion(foreverYoung,5)).

cantante(hatsuneMiku,cancion(tellYourWorld,5)).

cantante(gumi,cancion(foreverYoung,4)).
cantante(gumi,cancion(tellYourWorld,5)).

cantante(seeU,cancion(novemberRain,6)).
cantante(seeU,cancion(nightFever,4)).

cantante(flojo,cancion(wasaa,2)).

cantante(flojoYMuchosTemas,cancion(wasaa,2)).
cantante(flojoYMuchosTemas,cancion(wasup,3)).

% 1. Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.

novedoso(Cantante) :- 
    sabeAlMenosDosCanciones(Cantante),
    tiempoTotalCanciones(Cantante, Tiempo),
    Tiempo < 15.
    
sabeAlMenosDosCanciones(Cantante) :-
    cantante(Cantante, UnaCancion),
    cantante(Cantante, OtraCancion),
    UnaCancion \= OtraCancion.

tiempoTotalCanciones(Cantante, TiempoTotal) :-
    findall(TiempoCancion, 
    tiempoDeCancion(Cantante, TiempoCancion), Tiempos), sumlist(Tiempos,TiempoTotal).
    
tiempoDeCancion(Cantante,TiempoCancion):-  
    cantante(Cantante,Cancion),
    tiempo(Cancion,TiempoCancion).
    
tiempo(cancion(_, Tiempo), Tiempo).
    

% 2. Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2.

acelerado(Cantante):-
    vocaloid(Cantante),
    not((tiempoDeCancion(Cantante,Tiempo),Tiempo > 4)).
vocaloid(Cantante):-
    cantante(Cantante,_).

%%%%%%%%%%CONCIERTOS%%%%%%%% 

% 1)
concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).
concierto(magicalMirai,japon,3000,gigante(3,10)).
concierto(vocalektVision,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,diminuto(4)).


% 2)
puedeParticipar(hastuneMiku,Concierto):-
    concierto(Concierto,_,_,_).

puedeParticipar(Cantante,Concierto):-
    vocaloid(Cantante),
    Cantante \= hastuneMiku,
    concierto(Concierto,_,_,Requisitos),
    cumpleRequsitos(Cantante,Requisitos).

cumpleRequsitos(Cantante,gigante(CantCanciones,TiempoMinimo)):-
    cantidadCanciones(Cantante,Cantidad),
    Cantidad >= CantCanciones,
    tiempoTotalCanciones(Cantante,Total),
    Total > TiempoMinimo.

cumpleRequsitos(Cantante,mediano(TiempoMaximo)):-
    tiempoTotalCanciones(Cantante,Total),
    Total < TiempoMaximo.

cumpleRequisitos(Cantante, diminuto(TiempoMinimo)):-
	cantante(Cantante, Cancion),
	tiempo(Cancion, Tiempo),
	Tiempo > TiempoMinimo.

cantidadCanciones(Cantante, Cantidad) :- 
    findall(Cancion, cantante(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

% 3)
masFamoso(Cantante):-
    nivelFamoso(Cantante, NivelMasFamoso),
    forall(nivelFamoso(_,Nivel), NivelMasFamoso >= Nivel).

nivelFamoso(Cantante, Nivel):- 
    famaTotal(Cantante, FamaTotal), 	cantidadCanciones(Cantante, Cantidad), 
    Nivel is FamaTotal * Cantidad.
    
    famaTotal(Cantante, FamaTotal):- 
    vocaloid(Cantante),
    findall(Fama, famaConcierto(Cantante, Fama),  
    CantidadesFama), 	
    sumlist(CantidadesFama, FamaTotal).
    
    famaConcierto(Cantante, Fama):-
    puedeParticipar(Cantante,Concierto),
    fama(Concierto, Fama).
    
    fama(Concierto,Fama):- 
    concierto(Concierto,_,Fama,_).

% 4)

conoce(megurineLuka,hastuneMiku).
conoce(megurineLuka,gumi).
conoce(gumi,seeU).
conoce(seeU,kaito).

unicoParticipanteEntreConocidos(Cantante,Concierto):- 
    puedeParticipar(Cantante, Concierto),
	not((conocido(Cantante, OtroCantante), 
    puedeParticipar(OtroCantante, Concierto))).

%Conocido directo
conocido(Cantante, OtroCantante) :- 
conoce(Cantante, OtroCantante).

%Conocido indirecto
conocido(Cantante, OtroCantante) :- 
conoce(Cantante, UnCantante), 
conocido(UnCantante, OtroCantante).



% 5)
% En la solución planteada habría que agregar una claúsula en el predicado cumpleRequisitos/2  que tenga en cuenta el nuevo functor con sus respectivos requisitos 

% El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento en particular a cada uno de los conciertos en la cabeza de la cláusula.