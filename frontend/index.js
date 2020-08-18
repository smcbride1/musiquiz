const hostname = "http://localhost:3000";

//Renders base divs, should always be rendered first
function renderInitial() {
    document.querySelector(".logo").addEventListener("click", () => renderHome())
    let contentWrap = document.querySelector("div#content-wrap");
    contentWrap.appendChild(document.createElement("br"));
    let wrapper = document.querySelector("div.wrapper");
}

//Renders home
function renderHome() {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    h1.innerText = "Die Hard Fan?";
    wrapper.appendChild(h1);

    let h2 = document.createElement("h2");
    h2.innerText = "Test your knowledge";
    wrapper.appendChild(h2);

    h2 = document.createElement("h2");
    h2.innerText = "Search for your favorite artist";
    wrapper.appendChild(h2);

    wrapper.appendChild(document.createElement("br"));

    let input = document.createElement("input");
    input.type = "text";
    input.id = "search-text";
    input.placeholder = "Search...";
    wrapper.appendChild(input);

    let button = document.createElement("button");
    button.id = "search-button";
    button.innerText = "Search";
    button.addEventListener("click", () => renderQuizLobby(input.value));
    wrapper.appendChild(button);

    wrapper.appendChild(document.createElement("br"));
    wrapper.appendChild(document.createElement("br"));

    let cardContainer = document.createElement("div");
    cardContainer.className = "card-container";
    wrapper.appendChild(cardContainer);

    getRequest(`${hostname}/top_artists`, renderArtistCards);
};

//Renders mutliple artist cards
function renderArtistCards(artistHash) {
    for (let artist of artistHash) {
        renderArtistCard(artist.name, artist.img_url);
    }
}

//Renders single artists card
function renderArtistCard(artistName, imgUrl) {
    let truncatedArtistName = artistName.substring(0, 17);
    let cardContainer = document.querySelector(".card-container");

    let a = document.createElement("a");
    cardContainer.appendChild(a);

    let div = document.createElement("div");
    div.className = "card";
    a.appendChild(div);
    div.addEventListener("click", () => renderQuizLobby(artistName));

    let img = document.createElement("img");
    img.src = imgUrl;
    img.alt = truncatedArtistName;
    img.style = "width: 174px";
    div.appendChild(img);

    let div2 = document.createElement("div");
    div2.className = "container";
    div.appendChild(div2);

    let p = document.createElement("p");
    p.innerText = truncatedArtistName;
    div2.appendChild(p);
}

//Renders quiz lobby (pre quiz area)
function renderQuizLobby(artistName) {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    h1.innerText = `Take The ${artistName} Quiz!`;
    wrapper.appendChild(h1);

    let h2 = document.createElement("h2");
    h2.innerText = "Enter your name:";
    wrapper.appendChild(h2);

    wrapper.appendChild(document.createElement("br"));

    let input = document.createElement("input");
    input.type = "text";
    input.id = "name-text";
    input.placeholder = "Name...";
    wrapper.appendChild(input);

    let button = document.createElement("button");
    button.id = "start-button";
    button.innerText = "Start";
    button.addEventListener("click", () => renderQuiz(artistName))
    wrapper.appendChild(button);
}


//Renders loading spinner and text
function renderLoadingScreen(text) {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    h1.innerText = text;
    wrapper.appendChild(h1);

    wrapper.appendChild(document.createElement("br"));

    let loadingSpinner = document.createElement("div")
    loadingSpinner.id = "loading";
    wrapper.appendChild(loadingSpinner);
}

//Renders loading screen and fetches quizzes
function renderQuiz(artistName) {
    clearWrapper();
    renderLoadingScreen("Generating your quiz, please wait");
    getRequest(`${hostname}/quizzes/generate?q=${artistName}&length=${10}`, startQuiz);
}

//Creates new QuizAttempt and renders first question
function startQuiz(quiz) {
    let quizAttempt = new QuizAttempt(quiz.id);
    renderQuestion(quiz, quizAttempt);
}

//Renders a question as well as it's choices
function renderQuestion(quiz, quizAttempt, questionIndex=0) {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    let questionText;
    switch(quiz.questions[questionIndex].question_type) {
        case "guess_the_song_title":
            questionText = "What is the name of this song?"
        break;
    };
    h1.innerText = questionText;
    wrapper.appendChild(h1);

    for (let i = 0; i < quiz.questions[questionIndex].question_choices.length; i++) {
        let choice = quiz.questions[questionIndex].question_choices[i];
        let button = document.createElement("button");
        button.id = "choice-button";
        button.name = choice.id;
        button.innerText = choice.text;
        button.addEventListener("click", () => answerQuestion(quiz, quizAttempt, questionIndex, i));
        wrapper.appendChild(button);
    }

    let audio = document.createElement("audio");
    audio.volume = 0.5;
    audio.src = quiz.questions[questionIndex].itunes_preview_url;
    audio.autoplay = true;
    wrapper.appendChild(audio);
}

//Checks if answer was correct, updates current quizAttempt, and renders the next question
function answerQuestion(quiz, quizAttempt, questionIndex, answerIndex) {
    let correct = answerIndex === quiz.questions[questionIndex].answer;
    let questionAttempt = new QuestionAttempt(questionIndex, correct);
    quizAttempt.questionAttempts.push(questionAttempt);
    renderQuestionResult(quiz, quizAttempt, questionIndex, correct);
}

//Renders result of an answer
function renderQuestionResult(quiz, quizAttempt, questionIndex, correct) {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    h1.innerText = correct ? "Correct!" : "Incorrect";
    wrapper.appendChild(h1);

    let h2 = document.createElement("h2");
    h2.innerText = `Answer: ${quiz.questions[questionIndex].question_choices[quiz.questions[questionIndex].answer].text}`;
    wrapper.appendChild(h2);

    let button = document.createElement("button");
    button.id = "next-button";
    button.innerText = "Next Question";
    if (quiz.questions.length > questionIndex + 1) {
        button.addEventListener("click", () => renderQuestion(quiz, quizAttempt, questionIndex + 1));
    } else {
        button.addEventListener("click", () => renderQuizResult(quiz, quizAttempt));
    }
    wrapper.appendChild(button);
}

//Renders result of a quiz
function renderQuizResult(quiz, quizAttempt) {
    clearWrapper();
    let wrapper = document.querySelector("div.wrapper");
    let h1 = document.createElement("h1");
    h1.innerText = "Quiz Complete!";
    wrapper.appendChild(h1);

    let correctCount = quizAttempt.questionAttempts.map((e) => +e.correct).reduce((t, e) => t + e);
    let totalCount = quizAttempt.questionAttempts.length;
    let h2 = document.createElement("h2");
    h2.innerText = `Score: ${correctCount}/${totalCount}`;
    wrapper.appendChild(h2);

    let button = document.createElement("button");
    button.id = "home-button";
    button.innerText = "Home";
    button.addEventListener("click", () => renderHome());
    wrapper.appendChild(button);
}

//General get resquest function
function getRequest(url, func) {
    fetch(url)
        .then(response => response.json())
        .then(func);
}

//Clears wrapper of all content
function clearWrapper() {
    document.querySelector(".wrapper").innerHTML = "";
}

class QuestionAttempt {
    constructor(questionId, correct) {
        this.questionId = questionId;
        this.correct = correct;
    }
}

class QuizAttempt {
    constructor(quizId) {
        this.quizId = quizId;
        this.questionAttempts = [];
    }
}

renderInitial();
renderHome();