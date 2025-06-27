<template>
    <div class="container text-center px-4 mt-4">
		<div class="col-12 text-white border-custom ">
			<div class="row">
			  <div class="12 p-3 mb-1 d-flex justify-content-center align-items-center">

					<div class="d-flex flex-column align-items-center me-3">
                        <button class="btn btn-success mb-2 rounded-circle" @click="incrementMinutes">+</button>
                        <button class="btn btn-success rounded-circle" @click="decrementMinutes">-</button>
                    </div>

                    <div class="text-center">
                        <div class="fs-2 mb-2">{{ formattedTime }}</div>
                    </div>

                    <div class="d-flex flex-column align-items-center ms-3">
                        <button class="btn btn-success mb-2 rounded-circle" @click="incrementSeconds">+</button>
                        <button class="btn btn-success rounded-circle" @click="decrementSeconds">-</button>
                    </div>
			   </div>
			</div>

			<div class="d-flex mb-2 gap-1 justify-content-center flex-wrap">
				<button
					class="btn btn-sm w-49 w-md-auto"
					:class="isRunning ? 'btn-danger' : 'btn-success'"
					@click="startTimer"
				>
					{{ isRunning ? 'Stop' : 'Start' }}
				</button>
				<button class="btn btn-secondary text-light btn-sm w-48 w-md-auto" @click="resetTime">
					Redefinir tempo
				</button>
			</div>
       </div>
      <div class="row text-white mb-4">

        <div class="col-6 p-2">
		  <div class="p-3 border-custom shadow">
            <p>Games: <span class="fw-bold">{{ player1Games }}</span></p>
            <input v-model="player1" class="form-control mb-3 text-center text-white border-input" placeholder="Jogador 1" disabled readonly />
            <div class="d-flex mb-2 justify-content-between align-items-center" v-for="(value, set) in setPlayer1" :key="set" v-if="value!==null">
                <button v-if="value!==null" class="btn btn-outline-primary rounded-circle" @click="decrementSetPlayer1(set)">-</button>
                <span   v-if="value!==null" class="fs-3 px-2">{{ value }}</span>
                <button v-if="value!==null" class="btn btn-outline-primary rounded-circle" @click="incrementSetPlayer1(set)">+</button>
            </div>
            <div class="d-flex mb-2 justify-content-between align-items-center">
                <button :class="deuceRule === 'advantage'? 'btn btn-success rounded-circle': deuceRule==='goldenPoint'?'btn btn-warning text-white rounded-circle':'btn btn-primary rounded-circle'" @click="decrementPlayer1">-</button>
                <span class="fs-3 px-2">{{ player1Score }}</span>
                <button :class="deuceRule === 'advantage'? 'btn btn-success rounded-circle': deuceRule==='goldenPoint'?'btn btn-warning text-white rounded-circle':'btn btn-primary rounded-circle'" @click="incrementPlayer1" :disabled="gameOver || isTieBreak">+</button>
            </div>
          </div>
        </div>


        <div class="col-6 p-2">
		 <div class="p-3 border-custom shadow">
			<p>Games: <span class="fw-bold">{{ player2Games }}</span></p>
			<input v-model="player2" class="form-control mb-3 text-center text-white border-input" read-only placeholder="Jogador 2" disabled readonly />
			<div class="d-flex mb-2 justify-content-between align-items-center" v-for="(value, set) in setPlayer2" :key="set" v-if="value!==null">
				<button v-if="value!==null"  class="btn btn-outline-primary rounded-circle" @click="decrementSetPlayer2(set)">-</button>
				<span   v-if="value!==null" class="fs-3 px-2">{{ value }}</span>
				<button v-if="value!==null" class="btn btn-outline-primary rounded-circle" @click="incrementSetPlayer2(set)">+</button>
			</div>
			<div class="d-flex mb-2 justify-content-between align-items-center">
				<button :class="deuceRule === 'advantage'? 'btn btn-success rounded-circle': deuceRule==='goldenPoint'?'btn btn-warning text-white rounded-circle':'btn btn-primary rounded-circle'" @click="decrementPlayer2">-</button>
				<span class="fs-3 px-2">{{ player2Score }}</span>
				<button :class="deuceRule === 'advantage'? 'btn btn-success rounded-circle': deuceRule==='goldenPoint'?'btn btn-warning text-white rounded-circle':'btn btn-primary rounded-circle'" @click="incrementPlayer2" :disabled="gameOver || isTieBreak">+</button>
			</div>
          </div>
        </div>

        <div class="col-12 px-5 mb-2">
            <div class="row">
                <div v-if="false" class="col-12 border-custom  d-flex justify-content-center align-items-center mb-2">

                    <div class="d-flex justify-content-center align-items-center px-4 py-2">

                    <button class="btn btn-primary rounded-circle btn-custom me-3" @click="decrement">-</button>

                    <span class="fs-1 fw-bold mx-2">{{ gameParts }}</span>

                    <button class="btn btn-primary rounded-circle btn-custom ms-3" @click="increment">+</button>
                    </div>
                </div>

                <div class="col-12">
					<!--<div class="d-flex justify-content-center">
                        <button
                            class="btn btn-lg w-100"
                            :class="isRunning ? 'btn-danger' : 'btn-success'"
                            @click="startTimer"
                            >
                            {{ isRunning ? 'Stop' : 'Start' }}
                        </button>
                    </div> -->
					<div class="p-3 border-custom shadow"  v-if="player1Score === 40 && player2Score === 40">
                          <p class="fs-4 fw-bolder">Escolha a regra do Deuce </p>
                          <div class="row g-3  align-items-center">
                            <div class="col">
                              <div class="form-check form-check-inline">
                                <input class="form-check-input cursor-pointer" type="radio"  id="gridRadios1" v-model="deuceRule" value="advantage" >
                                <label class="form-check-label" for="gridRadios1">
                                  Vantagem
                                </label>
                            </div>
                            </div>
                            <div class="col">
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" id="gridRadios1" v-model="deuceRule" value="goldenPoint">
									<label class="form-check-label" for="gridRadios2">
									Ponto de Ouro
									</label>
								</div>
							   </div>
							</div>
                          </div>

                    <div v-if="isTieBreak">
                      <h3>Tie-Break!</h3>
                      <p>Jogador 1: {{ tieBreakPlayer1 }} - Jogador 2: {{ tieBreakPlayer2 }}</p>
                      <div class="d-flex mb-4 gap-5 flex-wrap justify-content-center">
                        <button class="btn btn-success mb-2 rounded-circle" @click="incrementTieBreakPlayer1">+1</button>
                        <button class="btn btn-success mb-2 rounded-circle" @click="incrementTieBreakPlayer2">+1</button>
                      </div>
                    </div>
                    <div v-if="gameOver" class="text-center mt-3">
                      <h3 class="text-success">Jogo Finalizado! 🎾</h3>
                    </div>
                </div>
            </div>
        </div>

      </div>

    </div>
  </template>
  
  <script setup>
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
  import { storeToRefs } from "pinia";
  import { ref, computed,onMounted,watch } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import { io } from 'socket.io-client';
  import useContentDefault from "@/stores/ContentStore"
  const contentStoreDefault = useContentDefault();



const socket = io(import.meta.env.VITE_WEBSOCKT_BASE_URL || 'http://localhost:3007'); 

const route = useRoute();

const hideBoard=ref(true)


const player1Score = ref(0);
const player2Score = ref(0);
const player1Games = ref(0);
const player2Games = ref(0);

const gameParts  = ref(1);

const sponsor = ref('');

const currentSet = ref(1);
const player1Sets = ref(0);
const player2Sets = ref(0);
const gameOver = ref(false); 

const isTieBreak = ref(false);
const tieBreakPlayer1 = ref(0);
const tieBreakPlayer2 = ref(0);

const player1 = ref('Home');
const setPlayer1=ref({
  set1:0,
  set2:null,
  set3:null
})

const player2 = ref('Away');
const setPlayer2=ref({
  set1:0,
  set2:null,
  set3:null
})


const scores = ref({
  player1: 0,
  player2: 0,
});


const setType = ref('normal'); 

const deuceRule = ref(''); 
  

const timer = ref(0); 
const isRunning = ref(false);
const interval = ref(null);


function displayPoints(points) {
  if (points === 0) return '0';
  if (points === 1) return '15';
  if (points === 2) return '30';
  if (points === 3) return '40';
  return 'Vantagem';
}


  const formattedTime = computed(() => {
    const minutes = String(Math.floor(timer.value / 60)).padStart(2, '0');
    const seconds = String(timer.value % 60).padStart(2, '0');
    return `${minutes}:${seconds}`;
  });


  const incrementMinutes = () => (timer.value += 60);
  const decrementMinutes = () => {
    if (timer.value >= 60) timer.value -= 60;
  };
  const incrementSeconds = () => (timer.value += 1);
  const decrementSeconds = () => {
    if (timer.value > 0) timer.value -= 1;
  };
  


const setWinner = computed(() => {
  if (setType.value === 'normal') {
    if (player1Games.value >= 6 && player1Games.value - player2Games.value >= 2) {
      return 'Jogador 1';
    } else if (player2Games.value >= 6 && player2Games.value - player1Games.value >= 2) {
      return 'Jogador 2';
    }
    if (player1Games.value === 6 && player2Games.value === 6) {
      isTieBreak.value = true;
      return 'Tie-Break';
    }
  } else if (setType.value === 'pontosCorridos') {
    if (player1Games.value === 9) {
      return 'Jogador 1';
    } else if (player2Games.value === 9) {
      return 'Jogador 2';
    }
    if (player1Games.value === 9 && player2Games.value === 9) {
      isTieBreak.value = true;
      return 'Tie-Break';
    }
  }
  return 'Nenhum';
});


const winner = computed(() => {
  if (gameOver.value) {
    return player1Sets.value > player2Sets.value ? 'Jogador 1' : 'Jogador 2';
  }
  return 'Jogo em andamento';
});


function incrementPlayer1() {
  if (player1Score.value === 40 && player2Score.value === 40) {
    applyDeuceRule('player1');
  } else if (player1Score.value === 40) {

    player1Score.value = 0;
    player2Score.value = 0;
    player1Games.value++;
    updateSetScore('player1');
    checkSetWinner();
  } else {

    player1Score.value = nextScore(player1Score.value);
  }
}

function incrementPlayer2() {
  if (player2Score.value === 40 && player1Score.value === 40) {
    applyDeuceRule('player2');
  } else if (player2Score.value === 40) {

    player2Score.value = 0;
    player1Score.value = 0;
    player2Games.value++;
    updateSetScore('player2');
    checkSetWinner();
  } else {

    player2Score.value = nextScore(player2Score.value);
  }
}

function decrementPlayer1() {
  if (player1Score.value === 0) return; 
  if (player1Score.value === 15) {
    player1Score.value = 0;
  } else if (player1Score.value === 30) {
    player1Score.value = 15;
  } else if (player1Score.value === 40) {
    player1Score.value = 30;
  } else if (player1Score.value === 40 && player2Score.value === 40 && deuceRule.value === 'advantage') {

    player1Score.value = 40;
    player2Score.value = 40;
  }
}

function decrementPlayer2() {
  if (player2Score.value === 0) return;
  if (player2Score.value === 15) {
    player2Score.value = 0;
  } else if (player2Score.value === 30) {
    player2Score.value = 15;
  } else if (player2Score.value === 40) {
    player2Score.value = 30;
  } else if (player2Score.value === 40 && player1Score.value === 40 && deuceRule.value === 'advantage') {

    player2Score.value = 40;
    player1Score.value = 40;
  }
}



function applyDeuceRule(winner) {
  if (deuceRule.value === 'advantage') {

    if (winner === 'player1') {
      player1Score.value = 40; 
      player2Score.value = 30;
    } else {
      player2Score.value = 40; 
      player1Score.value = 30;
    }
  } else if (deuceRule.value === 'goldenPoint') {

    if (winner === 'player1') {
      player1Score.value = 0;
      player2Score.value = 0;
      player1Games.value++;
      updateSetScore('player1');
      checkSetWinner();
      deuceRule.value=''
    } else {
      player2Score.value = 0;
      player1Score.value = 0;
      player2Games.value++;
      updateSetScore('player2');
      checkSetWinner();
      deuceRule.value=''
    }
  }
}


function nextScore(currentScore) {
  if (currentScore === 0) return 15;
  if (currentScore === 15) return 30;
  if (currentScore === 30) return 40;
  return 0;
}


function checkSetWinner() {
  if (setWinner.value === 'Jogador 1') {
    player1Sets.value++;
    updateSetScore('player1');
    resetGame();
    if (setType.value === 'pontosCorridos' || player1Sets.value === 2) {

      gameOver.value = true;
    } else if (player1Sets.value < 3) {
      currentSet.value++;
    }
  } else if (setWinner.value === 'Jogador 2') {
    player2Sets.value++;
    updateSetScore('player2');
    resetGame();
    if (setType.value === 'pontosCorridos' || player2Sets.value === 2) {

      gameOver.value = true;
    } else if (player2Sets.value < 3) {
      currentSet.value++;
    }
  }
}


function updateSetScore(player, isTieBreak = false) {
  if (player === 'player1') {
    if (currentSet.value === 1) {
      setPlayer1.value.set1 = isTieBreak ? 7 : player1Games.value;
    } else if (currentSet.value === 2) {
      setPlayer1.value.set2 = isTieBreak ? 7 : player1Games.value;
    } else if (currentSet.value === 3) {
      setPlayer1.value.set3 = isTieBreak ? 7 : player1Games.value;
    }
  } else if (player === 'player2') {
    if (currentSet.value === 1) {
      setPlayer2.value.set1 = isTieBreak ? 7 : player2Games.value;
    } else if (currentSet.value === 2) {
      setPlayer2.value.set2 = isTieBreak ? 7 : player2Games.value;
    } else if (currentSet.value === 3) {
      setPlayer2.value.set3 = isTieBreak ? 7 : player2Games.value;
    }
  }
}


function incrementTieBreakPlayer1() {
  if (tieBreakPlayer1.value < 7 || tieBreakPlayer1.value - tieBreakPlayer2.value < 2) {
    tieBreakPlayer1.value++;
    checkTieBreakWinner();
  }
}

function incrementTieBreakPlayer2() {
  if (tieBreakPlayer2.value < 7 || tieBreakPlayer2.value - tieBreakPlayer1.value < 2) {
    tieBreakPlayer2.value++;
    checkTieBreakWinner();
  }
}


function checkTieBreakWinner() {
  if (tieBreakPlayer1.value >= 7 && tieBreakPlayer1.value - tieBreakPlayer2.value >= 2) {
    player1Sets.value++;
    updateSetScore('player1', true); 
    resetTieBreak();
    if (player1Sets.value === 2) {
      gameOver.value = true; 
    } else if (player1Sets.value < 3) {
      currentSet.value++;
    }
  } else if (tieBreakPlayer2.value >= 7 && tieBreakPlayer2.value - tieBreakPlayer1.value >= 2) {
    player2Sets.value++;
    updateSetScore('player2', true); 
    resetTieBreak();
    if (player2Sets.value === 2) {
      gameOver.value = true; 
    } else if (player2Sets.value < 3) {
      currentSet.value++;
    }
  }
}


function resetGame() {
  player1Score.value = 0;
  player2Score.value = 0;
  player1Games.value = 0;
  player2Games.value = 0;

  if (currentSet.value === 1) {
    setPlayer1.value.set2 = 0;
    setPlayer2.value.set2 = 0;
  } else if (currentSet.value === 2) {
    if (player1Sets.value === 2 || player2Sets.value === 2) {
      setPlayer1.value.set3 = null;
      setPlayer2.value.set3 = null;
    } else {
      setPlayer1.value.set3 = 0;
      setPlayer2.value.set3 = 0;
    }
  }
}



function resetTieBreak() {
  tieBreakPlayer1.value = 0;
  tieBreakPlayer2.value = 0;
  isTieBreak.value = false;
  resetGame();
}


function resetMatch() {
  player1Score.value = 0;
  player2Score.value = 0;
  player1Games.value = 0;
  player2Games.value = 0;
  player1Sets.value = 0;
  player2Sets.value = 0;
  tieBreakPlayer1.value = 0;
  tieBreakPlayer2.value = 0;
  isTieBreak.value = false;
  gameOver.value = false;
  currentSet.value = 1;
  hideBoard.value=true

  setPlayer1.value = {
    set1: 0,
    set2: null,
    set3: null,
  };
  setPlayer2.value = {
    set1: 0,
    set2: null,
    set3: null,
  };
}


watch(setType, () => {
  resetMatch();
});

const increment = () => gameParts .value++;
  const decrement = () => {
  if (gameParts .value > 0) gameParts .value--;
  };

  const incrementSetPlayer1 = (set) =>{ 
    setPlayer1.value[set]++;
  }
  const decrementSetPlayer1 = (set) => {
    if (setPlayer1.value[set] > 0) setPlayer1.value[set]--;
  };


  const incrementSetPlayer2 = (set) => setPlayer2.value[set]++;
  const decrementSetPlayer2 = (set) => {
    if (setPlayer2.value[set] > 0) setPlayer2.value[set]--;
  };
  

  
  const startTimer = () => {
    if (isRunning.value) {
      clearInterval(interval.value);
      isRunning.value = false;

      socket.emit('updateTimer', {
        timer: timer.value,
        isRunning: isRunning.value,
        code: route.query.code || '',
      });
    } else {
      interval.value = setInterval(() => {
        timer.value++;
     
        socket.emit('updateTimer', { timer: timer.value, code: route.query.code || '',isRunning: true });
      }, 1000);
      isRunning.value = true;
    }
  };
  
  const startStreaming = () => {
    const data = {
      code:route.query.code || '',
      currentSet:currentSet.value || 1,
      player1: player1.value,
      setPlayer1:setPlayer1.value,
      player2: player2.value,
      setPlayer2:setPlayer2.value,
      sponsor: sponsor.value,
      player1Games: player1Games.value,
      player2Games: player2Games.value,
      player1Score: player1Score.value,
      player2Score: player2Score.value,
      scores: scores.value,
      hideBoard:hideBoard.value,
      gameOver:gameOver.value,
      deuceRule:deuceRule.value || '',
      timer: timer.value,
    };
  
   socket.emit('updateGame', data);

   const code = route.query.code || '';
   const url = `/broadcast?code=${code}`;
   const newWindow = window.open(url, '_blank');
  

  newWindow.onload = () => {
    socket.emit('updateGame', data);  
  };
 };


socket.on('timerUpdated', (data) => {
  if (data.code === route.query.code) {
    timer.value = data.timer; 
    isRunning.value = data.isRunning; 
  }
});

 socket.on('gameUpdated', (data) => {
  if (data.code === route.query.code) {
    deuceRule.value=data.deuceRule || ''
    currentSet.value=data.currentSet || 1
    sponsor.value=data.sponsor || ''
    hideBoard.value=data.hideBoard || true
    gameOver.value=data.gameOver || false,
    player1.value= data.player1|| 'Home'
    player2.value= data.player2|| 'Away'
    setPlayer1.value.set1=data.setPlayer1.set1 || 0
    setPlayer1.value.set2=data.setPlayer1.set2 || null
    setPlayer1.value.set3=data.setPlayer1.set3 || null
    setPlayer2.value.set1=data.setPlayer2.set1 || 0
    setPlayer2.value.set2=data.setPlayer2.set2 || null
    setPlayer2.value.set3=data.setPlayer2.set3 || null

    player1Games.value= data.player1Games ||0,
    player2Games.value= data.player2Games ||0,
    player1Score.value= data.player1Score ||0,
    player2Score.value= data.player2Score ||0

    scores.value.player1=data.scores.player1
    scores.value.player2=data.scores.player2
  }
});
  const resetTime = () => {
    timer.value = 0;
   };
  const resetAll = () => {
    deuceRule.value=''
    currentSet.value = 1;
    sponsor.value= ''
    hideBoard.value= true
    isTieBreak.value= false
    gameOver.value = false
    player1.value='Home'
    player2.value='Away'
    player1Score.value = 0;
    player2Score.value = 0;
    player1Games.value = 0;
    player2Games.value = 0;
    setPlayer1.value.set1=0
    setPlayer1.value.set2=null
    setPlayer1.value.set3=null
    setPlayer2.value.set1=0
    setPlayer2.value.set2= null
    setPlayer2.value.set3=null
    timer.value = 0;
    scores.value.player1 = 0;
    scores.value.player2 = 0;
    gameParts.value=1
  };

watch([player1, player2, sponsor,hideBoard,gameOver,deuceRule, timer,player1Score,player2Score,player1Games,player2Games,scores.value,setPlayer1.value,setPlayer2.value], () => {
  const data = {
    currentSet:currentSet.value || 1,
    code: route.query.code || '',
    player1: player1.value || 'Home',
    setPlayer1:setPlayer1.value,
    player2: player2.value || 'Away',
    setPlayer2:setPlayer2.value,
    sponsor: sponsor.value || '',
    scores: scores.value,
    player1Score:player1Score.value,
    player2Score:player2Score.value,
    player1Games:player1Games.value,
    player2Games:player2Games.value,
    hideBoard:hideBoard.value,
    gameOver:gameOver.value,
    timer: timer.value,
    deuceRule:deuceRule.value
  };
  socket.emit('updateGame', data); 
});

  onMounted(() => {
    socket.emit('getGame', { code: route.query.code || '' });
    socket.emit('getTimer', { code: route.query.code || '' });
    socket.on('currentTimer', (data) => {
      if (data.code === route.query.code) {
        timer.value = data.timer;
        isRunning.value = data.isRunning;
 
      if (isRunning.value) {
        interval.value = setInterval(() => {
          timer.value++;
          socket.emit('updateTimer', {
            timer: timer.value,
            isRunning: true,
            code: route.query.code || '',
          });
        }, 1000);
      }
      }
    });
  });
  </script>
  
  <style scoped>
  .home{
  background-color: #033380;
  min-height: 100vh;
  display: flex;
  align-items: center;
}
  .placeholder-white::placeholder {
    color: white;
    opacity: 1; 
  }

  .custom-switch {
  width: 40px; 
  height: 20px; 
  transform: scale(1.5); 
  cursor: pointer;
}

.custom-switch:checked {
  background-color: #4caf50; 
}

.custom-switch:focus {
  box-shadow: 0 0 5px #4caf50;
}
  
  .btn {
    font-size: 1.2rem;
  }
  
  .btn.rounded-circle {
    width: 40px; 
    height: 40px; 
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  
  .fs-2 {
    font-weight: bold;
  }
  

  .border-custom {
    border: 2px solid #ccc;
    border-radius: 20px; 
    background-color: transparent; 
  }
  
 
  .border-input {
    border: 2px solid #ccc;
    border-radius: 10px;
    background-color: transparent;
  }
  </style>
  