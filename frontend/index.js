const hostname = "http://localhost:3000";

class Render {
    static querySelector(query) {
        if (typeof(query) === "string") {
            return document.querySelector(query);
        } else {
            return query;
        }
    }

    static h1(parent, innerText) {
        let h1 = document.createElement("h1");
        h1.innerText = innerText;
        this.querySelector(parent).appendChild(h1);
        return h1;
    }

    static h2(parent, innerText) {
        let h2 = document.createElement("h2");
        h2.innerText = innerText;
        this.querySelector(parent).appendChild(h2);
        return h2;
    }

    static br(parent) {
        let br = document.createElement("br");
        this.querySelector(parent).appendChild(br);
        return br;
    }

    static inputText(parent, id, placeholder) {
        let input = document.createElement("input");
        input.type = "text";
        input.id = id;
        input.placeholder = placeholder;
        this.querySelector(parent).appendChild(input);
        return input;
    }

    static button(parent, id, innerText, name="") {
        let button = document.createElement("button");
        button.id = id;
        button.innerText = innerText;
        if (!name) {
            button.name = name;
        }
        this.querySelector(parent).appendChild(button);
        return button;
    }

    static div(parent, className) {
        let div = document.createElement("div");
        div.className = className;
        this.querySelector(parent).appendChild(div);
        return div;
    }

    static a(parent) {
        let a = document.createElement("a");
        this.querySelector(parent).appendChild(a);
        return a;
    }

    static img(parent, imgUrl, alt, style) {
        let img = document.createElement("img")
        img.src = imgUrl;
        img.alt = alt;
        img.style = style;
        this.querySelector(parent).appendChild(img);
        return img;
    }

    static p(parent, innerText) {
        let p = document.createElement("p");
        p.innerText = innerText;
        this.querySelector(parent).appendChild(p);
        return p;
    }

    static audio(parent, volume, src, autoplay) {
        let audio = document.createElement("audio");
        audio.volume = volume;
        audio.src = src;
        audio.autoplay = autoplay;
        this.querySelector(parent).appendChild(audio);
        return audio;
    }
}

//Renders base divs, should always be rendered first
function renderInitial() {
    document.querySelector(".logo").addEventListener("click", () => renderHome());
    document.querySelector("#recent-results").addEventListener("click", () => getRequest(`${hostname}/results`, renderRecentResults));
    Render.br("div#content-wrap");
}

//Renders results
function renderRecentResults(results) {
    clearWrapper();
    Render.h1("div.wrapper", "Recent Results")

    for (let result of results.reverse()) {
        Render.h2("div.wrapper", `${result.name} scored ${result.correct_answer_count}/${result.total_question_count} on the ${result.quiz.name}`)
    }
}

//Renders home
function renderHome() {
    clearWrapper();

    Render.h1("div.wrapper", "Die Hard Fan?");
    Render.h2("div.wrapper", "Test your knowledge");
    Render.h2("div.wrapper", "Search for your favorite artist");

    Render.br("div.wrapper");

    Render.inputText("div.wrapper", "search-text", "Search...");

    Render.button("div.wrapper", "search-button", "Search").addEventListener("click", () => renderQuizLobby(document.querySelector("#search-text").value));

    Render.br("div.wrapper");
    Render.br("div.wrapper");

    Render.div("div.wrapper", "card-container");

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

    let a = Render.a(".card-container");
    a.addEventListener("click", () => renderQuizLobby(artistName));

    let card = Render.div(a, "card")

    Render.img(card, imgUrl, truncatedArtistName, "width: 174px");
    
    let container = Render.div(card, "container");

    Render.p(container, truncatedArtistName);
}

//Renders quiz lobby (pre quiz area)
function renderQuizLobby(artistName) {
    clearWrapper();
    Render.h1("div.wrapper", `Take The ${artistName} Quiz!`);
    Render.h2("div.wrapper", "Enter your name:");

    Render.br("div.wrapper");

    Render.inputText("div.wrapper", "name-text" ,"Name...");

    Render.button("div.wrapper", "start-button", "Start").addEventListener("click", () => renderQuiz(artistName, document.querySelector("#name-text").value));
}


//Renders loading spinner and text
function renderLoadingScreen(text) {
    clearWrapper();
    Render.h1("div.wrapper", text);

    Render.br("div.wrapper");

    Render.div("div.wrapper", "loading");
}

//Renders loading screen and fetches quizzes
function renderQuiz(artistName, userName) {
    renderLoadingScreen("Generating your quiz, please wait");
    fetch(`${hostname}/quizzes/generate?q=${artistName}&length=${10}`)
        .then(response => response.json())
        .then(json => startQuiz(json, userName));
}

//Creates new QuizAttempt and renders first question
function startQuiz(quiz, name) {
    let quizAttempt = new QuizAttempt(quiz.id, name);
    renderQuestion(quiz, quizAttempt);
}

//Renders a question as well as it's choices
function renderQuestion(quiz, quizAttempt, questionIndex=0) {
    clearWrapper();
    let questionText;
    switch(quiz.questions[questionIndex].question_type) {
        case "guess_the_song_title":
            questionText = "What is the name of this song?"
        break;
    };
    Render.h1("div.wrapper", questionText);

    for (let i = 0; i < quiz.questions[questionIndex].question_choices.length; i++) {
        let choice = quiz.questions[questionIndex].question_choices[i];
        let button = document.createElement("button");
        Render.button("div.wrapper", "choice-button", choice.text, choice.id).addEventListener("click", () => answerQuestion(quiz, quizAttempt, questionIndex, i));
    }

    Render.audio("div.wrapper", 0.5, quiz.questions[questionIndex].itunes_preview_url, true)
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
    Render.h1("div.wrapper", correct ? "Correct!" : "Incorrect");

    Render.h2("div.wrapper", `Answer: ${quiz.questions[questionIndex].question_choices[quiz.questions[questionIndex].answer].text}`);

    let button = Render.button("div.wrapper", "next-button", "Next Question");
    if (quiz.questions.length > questionIndex + 1) {
        button.addEventListener("click", () => renderQuestion(quiz, quizAttempt, questionIndex + 1));
    } else {
        button.addEventListener("click", () => createQuizResult(quiz, quizAttempt));
    }
}

function createQuizResult(quiz, quizAttempt) {
    renderLoadingScreen("Loading results");
    let correctCount = quizAttempt.questionAttempts.map((e) => +e.correct).reduce((t, e) => t + e);
    let totalCount = quizAttempt.questionAttempts.length;
    result = new Result(quiz.id, quizAttempt.name, correctCount, totalCount)
    let formData = new FormData();
    formData.append('result[quiz_id]', result.quizId);
    formData.append('result[name]', result.name);
    formData.append('result[correct_answer_count]', result.correctAnswerCount);
    formData.append('result[total_question_count]', result.totalQuestionCount);
    postRequest(`${hostname}/results`, formData, renderQuizResult(quiz, result));
}

//Renders result of a quiz
function renderQuizResult(quiz, result) {
    clearWrapper();
    Render.h1("div.wrapper", "Quiz Complete!")

    Render.h2("div.wrapper", `Score: ${result.correctAnswerCount}/${result.totalQuestionCount}`)

    Render.button("div.wrapper", "home-button", "Home").addEventListener("click", () => renderHome());
}

//General get request function
function getRequest(url, func) {
    fetch(url)
        .then(response => response.json())
        .then(func);
}

//General post request function
function postRequest(url, body, func) {
    fetch(url, {
        method: 'post',
        body: body
    })
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
    }QuizAttempt
}

class QuizAttempt {
    constructor(quizId, name) {
        this.quizId = quizId;
        this.name = name;
        this.questionAttempts = [];
    }
}

class Result {
    constructor(quizId, name, correctAnswerCount, totalQuestionCount) {
        this.quizId = quizId;
        this.name = name;
        this.correctAnswerCount = correctAnswerCount;
        this.totalQuestionCount = totalQuestionCount;
    }
}

renderInitial();
renderHome();