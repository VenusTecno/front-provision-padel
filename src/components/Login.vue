<template>
    <div class="page-container d-flex position-relative">

      <div class="col-md-6 p-0 position-relative image-container d-none d-md-block">
        <img
          src="@/assets/banner-tennis.jpg"
          alt="Banner Scoreboard"
          class="img-fluid w-100 h-100"
          style="object-fit: cover"
        />

        <div class="content-overlay d-flex flex-column justify-content-center align-items-center">
          <div class="text-center mb-4">
            <h1 class="fw-bold text-uppercase">
              Seja <span class="text-orange">Bem-Vindo</span> Ao
              <span class="text-blue"><strong>Scoreboard</strong></span>
            </h1>
          </div>
  
  
          <div class="row g-3 mb-4 w-75">
            <h6 class="text-center mb-4">
              Solução para a gestão de placares e resultados! Foi desenvolvida para oferecer uma experiência dinâmica e interativa no acompanhamento de pontuações, ideal para eventos esportivos, competições e jogos digitais.
            </h6>
            <h5 class="mb-3">Recursos Principais:</h5>
            <div
              class="col-6"
              v-for="(item, index) in cardData"
              :key="index"
              @click="openModal(item)"
            >
              <div class="card text-center shadow-sm card-hover p-3">
                <h6 class="fw-bold">{{ item.title }}</h6>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="col-md-6 d-flex flex-column justify-content-center align-items-center"
        style="background-color: #2a2a2a;"
      >

      <div class="w-50">

        <div class="text-center w-100 w-50">
            <img
            src="@/assets/provision.png"
            alt="logotipo provision"
            class="img-fluid provision-logo"
            />
        </div>

   
        <form @submit.prevent="handleLogin">
          <div class="mb-2 text-white">
            <label for="user" class="form-label">Utilizador</label>
            <input
              type="text"
              id="user"
              v-model="credentials.email"
              class="form-control"
              placeholder="Ex: Jorge*"
              required
            />
          </div>

          <div class="mb-3 text-white">
            <label for="password" class="form-label">Palavra-passe</label>
            <div class="input-group">
              <input
                :type="showPassword ? 'text' : 'password'"
                id="password"
                v-model="credentials.password"
                class="form-control"
                placeholder="Ex: 123456 *"
                required
              />
              <span
                class="input-group-text"
                @click="togglePassword"
                style="cursor: pointer"
              >
                <i class="bi" :class="showPassword ? 'bi-eye' : 'bi-eye-slash'"></i>
              </span>
            </div>
          </div>

 
          <div class="d-grid">
            <button type="submit" class="btn btn-danger btn-lg custom-button" :disabled="isLoadVisible">
                <span v-if="isLoadVisible==false">Entrar</span>
                <span v-if="isLoadVisible" class="spinner-grow spinner-grow-sm" aria-hidden="true"></span>
                <span v-if="isLoadVisible" role="status">Loading...</span>
            </button>
            <h6 class="mt-4 text-center text-white">
                Pronto para elevar a experiência do seu evento? Comece agora! 🚀
            </h6>
          </div>
        </form>
      </div>

      </div>
  

      <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
        <div class="modal-content p-4">
          <h4 class="fw-bold mb-3">{{ selectedItem.title }}</h4>
          <p>{{ selectedItem.description }}</p>
          <button class="btn btn-danger" @click="closeModal">Fechar</button>
        </div>
      </div>


        <div class="toast-container position-fixed top-0 end-0 p-3">
        <div
            id="liveToast"
            class="toast"
            role="alert"
            aria-live="assertive"
            aria-atomic="true"
            ref="toast"
        >
            <div class="toast-header text-white bg-danger">
            <font-awesome-icon class="text-white rounded me-2" :icon="['fas', 'user-secret']" />
            <strong class="me-auto text-white">Aviso</strong>
            <small class="fw-bold">{{returnsMonth(new Date())}}</small>
            <button
                type="button"
                class="btn-close btn-white text-white"
                data-bs-dismiss="toast"
                aria-label="Close"
            ></button>
            </div>
            <div class="toast-body">{{ message }}</div>
        </div>
        </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from "vue";
  import { useRouter } from "vue-router";
  import * as bootstrap from "bootstrap";
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

  import useAuthStore from "@/stores/auth/index"
  const authStore = useAuthStore();
  

  const router = useRouter();

  const message =ref('')

  const credentials = ref({
    email:"",
    password: null,
  })

const isLoadVisible=ref(false)
const showPassword = ref(false);
const toast = ref(null);



const showModal = ref(false);
const selectedItem = ref(null);


const togglePassword = () => {
  showPassword.value = !showPassword.value;
};

const showToast = () => {
  if (toast.value) {
    const bootstrapToast = new bootstrap.Toast(toast.value);
    bootstrapToast.show();
  }
};


const handleLogin = async () => {
  isLoadVisible.value = true
  const result = await authStore.login(credentials.value);
      if (result.code == 1) {
        setTimeout(() => {
          message.value='Acesso Permitido!! Bem-Vido/a  (^_-).'
          isLoadVisible.value = false
          router.push('/')
          showToast()
        }, 1000);
      }else if (result.code == 2) {
        isLoadVisible.value = false
        showSnackbar({
          location:"top end",
          color:"error",
          message: `Lamentamos, não poderá acessar a sua conta porque encontra-se inativa, por favor contacte o Administrador do sistema!`,
          transition:"scroll-y-reverse-transition",
          timeout: 3000,
        });
      } else if (result.code == 4) {
        message.value='Ups!!! Palavra-Passe Incorreta'
        isLoadVisible.value = false
        showToast()
      } else if (result.code == 5) {
        message.value='Ocorreu um erro, verifique a sua conexão.'
        isLoadVisible.value = false
        showToast()
      }
};
  const  returnsMonth = (created)=>{
    if (created)
    return new Date(created).toLocaleDateString('pt-PT', { year: 'numeric', month: 'numeric', day: 'numeric'})
    else return "------";
  }
  
  
  const cardData = [
    {
      title: "🏆 Resultados em Tempo Real",
      description: "Atualizações automáticas e sem esforço.",
    },
    {
      title: "💡 Fácil de Usar",
      description: "Interface amigável e intuitiva, sem complicação.",
    },
    {
      title: "⚙️ Altamente Personalizável",
      description:
        "Ajuste os placares conforme as regras e identidade do seu evento.",
    },
    {
      title: "🔔 Engajamento Garantido",
      description:
        "Mantenha o público informado e conectado durante toda a competição.",
    },
  ];

  

  const openModal = (item) => {
    selectedItem.value = item;
    showModal.value = true;
  };
  

  const closeModal = () => {
    showModal.value = false;
    selectedItem.value = null;
  };
  </script>
  
  <style scoped>

  .page-container {
    overflow: hidden;
    height: 100vh;
  }
  
.custom-button {
  max-width: 250px; 
  margin: 0 auto; 
}

  .text-orange {
    color: #f36c21;
  }
  
  .text-blue {
    color: #033380;
  }

.provision-logo {
  max-width: 260px; 
  height: auto; 
  margin: 0 auto;
  display: block; 
}
  

  .image-container {
    position: relative;
    height: 100vh;
  }
  
  .content-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 2;
    color: #fff;
    text-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
    padding: 20px;
    background: rgba(0, 0, 0, 0.5); 
  }
  
  img {
    position: relative;
    z-index: 1;
    object-fit: cover;
  }
  

  .card {
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
    background-color: #fff;
    border: none;
  }
  
  .card-hover:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  }
  

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }
  
  .modal-content {
    background: #fff;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
  }
  
  .modal-content button {
    display: block;
    margin: 0 auto;
  }
  </style>
  