/* Facts and rules */
% response for the first question, uses anonymous variable and will
% always give the same reply

response(_, " Whats your name?").

% Will figure out the most appropriate response
smalltalk_response(good, "Wonderful!").
smalltalk_response(bad, "That's terrible, Im sorry.").
smalltalk_response(_,"Hopefully the day will start to go better.").

%Will reply to the typr of feedback given
feedback_response(positive, "Thank you, we appreciate the positive feedback.").
feedback_response(negative, "Were sorry you had a poor experience.").
feedback_response(_, "All feedback is appreciated!").

% This database will be used to save the conversation between the user
% and the chatbot.
:- dynamic answer/1.
answer(_).

% This will start the program, write the greeting and respond
% reagardless of reply
start_conversation:-
    write("Hello there!"), nl,
    assert(answer("Hello there!")), nl,
    read(X), nl,
    assert(answer(X)),
    response(X, Y) ,nl,
    write(Y),nl,
    assert(answer(Y)),
    respond_response.

% This will read in the name of the user and save their name to a .txt
% file
respond_response:-
    read(X),nl,
    assert(answer(X)),
    write("Its nice to meet you "),
    write(X),nl,
    assert(answer("Its nice to meet you ")),
    assert(X),nl,
    smalltalk.

% This will ask how the users day was. If good or bad, a specific reply
% will be given, if not the program will give a generic response.
smalltalk:-
    write("Hows your day been?"),nl,
    assert(answer("Hows your day been?")),
    read(X), nl,
    smalltalk_response(X, Y), nl,
    write(Y), nl,
    assert(answer(X)),nl,
    assert(answer(Y)),nl,
    write("Here is the quiz for your meal."),nl,
    quiz,
    write("Is your feedback for us today positive or negative?"),nl,
    assert(answer("Is your feedback for us today positive or negative?")),
    discussion_and_feedback.

%This will ask the user for their feedback and save it to a .txt file
discussion_and_feedback:-
    read(X), nl,
    assert(answer(X)),
    feedback_response(X,Z), nl,
    write(Z),nl,
    assert(answer(Z)),nl,
    write("Please enter your feedback here in inverted commas: "),nl,
    read(Y),nl,
    open('feedback.txt', write, Stream),
    write(Stream, Y),
    close(Stream),
    write("Thank you, your feedback has been logged."),nl,
    write("Your feedback was : "),
    readfacts,
    %This will save the conversation as it had been stored in the database
    full_conversation,
    %This will wipe the database so that the old conversation file will be replaced by the new one
    write("Thank you for your patronage, your conversation has been recorded in conversation.txt, please visit us again!"),
    retractall(answer(_)).

% This function will read the string from the file and will relay the
% feedback to the customer. It will bw called at the end of the file.
readfacts:-
    open('feedback.txt',read,In),
    repeat,
    read_line_to_codes(In,X),writef(" "),
    writef(X),nl,
    %The code will check if the end of the file has been reached. If not it will backtrack and read the next line
    X=end_of_file,!,
    nl,
    close(In).

% This will save the database containing the conversation between the
% user and the chatbot to a separate file. Writeln is used to make sure
% that each item in the database will be diplayed on a new line.
full_conversation:-
   open('conversation.txt', write, Stream),
   (   answer(Answer),
       writeln(Stream, Answer), fail
   ;   true
   ),
   close(Stream).


/* This part of the program will check what food the user would enjoy*/
quiz:-
    test(Test),
    write("The perfect meal for you would be : "),
    assert(answer("The perfect meal for you would be : ")),
    write(Test), nl,
    assert(answer(Test)),
    undo.


%This part of the quiz will test for each possible food item
test(chickenparm) :- chickenparm, ! .
test(pizza) :- pizza , !.
test(burger) :- burger, ! .
test(bread) :- bread , !.
test(chicken) :- chicken, !.
test(cheese) :- cheese, ! .
test(salad) :- salad , ! .
test(air).


%This part will define what traits the food will have
salad :-
   healthy .

chickenparm :-
    meat,
    lactose,
    gluten.

burger :-
    meat,
    lactosefree,
    gluten.

pizza :-
    vegetarian,
    lactose,
    gluten.

chicken :-
    meat,
    lactosefree,
    glutenfree.

cheese :-
    vegetarian,
    lactose,
    glutenfree.

bread :-
    vegetarian,
    lactosefree,
    gluten.




%Classification rules
meat:-
    check("contain meat").
lactose:-
    check("contains lactose").
gluten:-
    check("contains gluten").
healthy:-
    check("None of the above").
vegetarian:-
    check("no meat").
lactosefree:-
    check("no lactose").
glutenfree:-
    check("no gluten").

%Ask questions
ask(Test) :-
     write("Does the food you want "),
     assert(answer("Does the food you want ")),
     write(Test),
     assert(answer(Test)),
     write('? '),
     read(A),
     assert(answer(A)),
     nl,
     ((A == yes ; A == y)
     ->
     asserta(yes(Test)) ;
     asserta(no(Test)), fail).

:- dynamic(yes/1,no/1).

check(S) :-
 (yes(S)
 ->
 true ;
 ( no(S)
 ->
 fail ;
 ask(S) )).

undo :- retract(yes(_)), fail.
undo :- retract(no(_)), fail.
undo.


