// Constructor for Notes
function Note(staff) {
  this.staff = staff;
  this.number = 0;
}

// Constructor for Staves
function Staff(voice) {
  this.voice = voice;
  this.node = document.getElementById(voice);
  this.notes = 0;
  this.pitches = [];
  this.activeNote = null;
  this.makeActive = function(note) {
    if (this.activeNote) this.activeNote.src = "images/note.png";
    this.activeNote = note;
    this.activeNote.src = "images/notecolor.png";
  };
  this.addNote = function() {
    if (this.notes >= 10) return false;
    var newNote = document.createElement("img");
    newNote.setAttribute("src", "images/note.png");
    this.node.appendChild(newNote);
    this.makeActive(newNote);
    this.notes++;
  };
  this.keyInput = function(e) {
    var move = false;
    var y;
    var keycode;
    // check/adjust for browser versions
    if (window.event) {
      keycode = window.event.keyCode;
    } else if (e) {
      keycode = e.which;
    }
    // assign keyboard actions
    switch(keycode) {
    case 38:
      move = true;
      y = -6
      break;
    case 40:
      move = true;
      y = 6
      break;
    case 39:
      if (this.activeNote === this.node.lastChild || this.activeNote === null) {
        this.addNote();
      } else {
        this.makeActive(this.activeNote.nextSibling);
      }
      break;
    case 37:
      if (this.activeNote !== this.node.firstChild) {
        this.makeActive(this.activeNote.previousSibling);
      }
      break;
    case 8:
      if (this.activeNote !== this.node.firstChild) {
        this.makeActive(this.activeNote.previousSibling);
        this.node.removeChild(this.activeNote.nextSibling);
        this.notes--;
      } else if (this.activeNote === this.node.firstChild) {
        this.activeNote = null;
        this.node.removeChild(this.node.firstChild);
      }
      break;
    default:
      alert(keycode);
      break;
    }
    if (move) {
      var top = parseInt(window.getComputedStyle(this.activeNote).top);
      if (top + y >= 0 && top + y <= 84) {
        this.activeNote.style.top = top + y + "%";
      }
    }
    e.preventDefault();
    return false;
  };
  var self = this;
  this.node.addEventListener('click', function(){self.addNote();}, false);
  this.node.addEventListener('keydown', function(e){self.keyInput(e);}, false);
}



// Main code for page

soprano = new Staff("soprano");
alto = new Staff("alto");
tenor = new Staff("tenor");
bass = new Staff("bass");
migrate = document.getElementById("migrate");
migrate.addEventListener('click', function(){fillPitches();}, false);



// Functions for 'Fill Pitches' input button

function getPitches(staff, inputId) {
  // get staff position of each note
  var positions = [];
  for (var i = 0, n = staff.node.childNodes.length; i < n; i++) {
    var y_pos = parseInt(window.getComputedStyle(staff.node.childNodes[i]).top);
    positions[i] = (84 - y_pos) / 6;
    if (staff.voice === "bass") positions[i] += 2;
  }
  // match staff position with pitch
  var pitchValues = [35, 36, 38, 40, 41, 43, 45, 47, 48, 50, 52, 53, 55, 57, 59, 60, 62, 64, 65]
  var pitches = [];
  var clef;
  switch(staff.voice) {
  case "bass":
    clef = 24;
    break;
  case "tenor":
    clef = 12;
    break;
  default:
    clef = 0;
    break;
  }
  for (var i = 0, n = positions.length; i < n; i++) {
    pitches[i] = pitchValues[positions[i]] - clef;
  }
  inputField = document.getElementById(inputId);
  inputField.value = pitches.toString();
}

function fillPitches() {
  variables = [[soprano, 's_input'], [alto, 'a_input'], [tenor, 't_input'], [bass, 'b_input']];
  for (var i = 0; i < 4; i++) {
    getPitches(variables[i][0], variables[i][1]);
  }
}
