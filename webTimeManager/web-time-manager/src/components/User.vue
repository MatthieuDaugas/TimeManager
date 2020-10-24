<template>
  <header>
    <div v-if="userId" class="header-contents">
      <div class="left">
        <div class="username-container">
          <span class="username"
            >Current user : <b>{{ username }}</b></span
          >
        </div>
      </div>
      <div class="center">
        <div class="today-container">
          <span class="today">{{ today }}</span>
        </div>
      </div>
      <div class="right">
        <div
          v-if="settingActive && createForm"
          id="createForm"
          class="header-form"
        >
          <form action=""></form>
        </div>
        <div
          v-if="settingActive && changeForm"
          id="changeForm"
          class="header-form"
        >
          <form action=""></form>
        </div>
        <div
          v-if="settingActive && updateForm"
          id="updateForm"
          class="header-form"
        >
          <form action=""></form>
        </div>
        <div
          v-if="settingActive && deleteForm"
          id="deleteForm"
          class="header-form"
        >
          <label for="">Confirm ?</label>
          <button>Yes</button>
        </div>

        <button
          id="settings-btn"
          v-bind:class="{ settingActive: settingActive }"
          @click.stop="activateSetting"
        >
          <div class="img-container">
            <img v-if="!settingActive" src="../assets/icons/settings.svg" />
            <img
              v-if="settingActive"
              src="../assets/icons/back-arrow.svg"
              alt=""
            />
          </div>
        </button>
        <div
          v-if="settingActive && dropDownActive"
          class="setting-dropdown"
          v-on:click.stop
        >
          <h2>User</h2>
          <ul>
            <li id="update" @click.stop="display('update')">Update</li>
            <li id="change" @click.stop="display('change')">Change</li>
            <li id="create" @click.stop="display('create')">Create</li>
            <li id="delete" @click.stop="display('delete')">Delete Current</li>
          </ul>
        </div>
      </div>
    </div>

    <div v-else class="center-card">
      <h1>Select or Create a user</h1>
      <b-form class="center-form" v-on:submit.prevent="getUser()">
        <label class="sr-only" for="inline-form-input-name">Name</label>
        <b-input
          class="card-input"
          id="inline-form-input-username"
          placeholder="Username"
        ></b-input>

        <label class="sr-only" for="inline-form-input-username">Username</label>
        <b-input-group prepend="@" class="card-input">
          <b-input id="inline-form-input-email" placeholder="Email"></b-input>
        </b-input-group>
        <div class="form-buttons">
          <button class="button-classic" variant="primary" type="submit">
            Get
          </button>
          <button
            class="button-classic"
            v-on:click="createUser()"
            variant="primary"
            type="button"
          >
            Create
          </button>
        </div>
        <span class="error card-form-error">{{ error }}</span>
      </b-form>
    </div>
  </header>
</template>

<script>
import axios from "axios";
import VueAxios from "vue-axios";
import Vue from "vue";
import moment from "moment";
Vue.use(VueAxios, axios);

export default {
  data: function() {
    return {
      userId: 1,
      username: "Azerty",
      email: "",
      settingActive: false,
      dropDownActive: false,
      isHidden: true,
      error: null,
      createForm: false,
      updateForm: false,
      changeForm: false,
      deleteForm: false,
      today: moment().format("LL")
    };
  },
  mounted() {
    document.addEventListener("click", this.closeDropDown);
  },
  methods: {
    closeDropDown: function() {
      this.dropDownActive = false;
      this.settingActive = false;

      this.createForm = false;
      this.updateForm = false;
      this.changeForm = false;
      this.deleteForm = false;
    },
    activateSetting: function() {
      this.settingActive = !this.settingActive;
      this.dropDownActive = this.settingActive;
      if (
        this.createForm ||
        this.updateForm ||
        this.changeForm ||
        this.deleteForm
      ) {
        this.settingActive = true;
        this.dropDownActive = true;
        this.createForm = false;
        this.updateForm = false;
        this.changeForm = false;
        this.deleteForm = false;
      }
    },
    display: function(type) {
      this.dropDownActive = false;
      this[`${type}Form`] = true;
    },
    getUser: function() {
      let username_el = document.getElementById("inline-form-input-username");
      let email_el = document.getElementById("inline-form-input-email");
      if (username_el.value == "" && email_el.value == "") {
        // Changer les couleurs des inputs
        email_el.style.borderColor = "red";
        username_el.style.borderColor = "red";
      } else if (email_el.value == "") {
        email_el.style.borderColor = "red";
      } else if (username_el.value == "") {
        username_el.style.borderColor = "red";
      } else {
        let query =
          "http://localhost:4000/api/users?username=" +
          username_el.value +
          "&email=" +
          email_el.value;
        axios
          .get(query)
          .then(response => {
            const user = response.data.data;
            console.log(user);
            if (user) {
              this.isHidden = false;
              this.username = user.username;
              this.email = user.email;
              this.userId = user.id;
              this.$store.dispatch("change", user.id);
            } else {
              console.log("User not found");
            }
          })
          .catch(error => console.log(error));
        if (this.$router.history.current.path !== "/dashboard") {
          this.$router.push("/dashboard");
        }
      }
    },

    updateUser: function() {
      let username_el = document.getElementById("inline-form-input-username");
      let email_el = document.getElementById("inline-form-input-email");
      let query = "http://localhost:4000/api/users/" + this.userId;
      axios
        .put(query, {
          username: username_el.value,
          email: email_el.value
        })
        .then(() => {
          this.username = username_el.value;
          this.email = email_el.value;
        });
    },

    deleteUser: function() {
      if (!this.userId) {
        alert("Cannot delete unselected user.");
      } else {
        let query = "http://localhost:4000/api/users/" + this.userId;
        axios.delete(query).then(() => {
          this.$store.dispatch("change", null);
          this.userId = null;
          this.email = null;
          this.username = null;
          this.isHidden = true;
        });
        alert("User " + this.username + " deleted.");
      }
    },

    logout: function() {
      this.userId = null;
      this.isHidden = true;
      this.$store.dispatch("change", null);
    },

    createUser: function() {
      let username_el = document.getElementById("inline-form-input-username");
      let email_el = document.getElementById("inline-form-input-email");

      if (username_el.value == "" && email_el.value == "") {
        // Changer les couleurs des inputs
        email_el.style.borderColor = "red";
        username_el.style.borderColor = "red";
      } else if (email_el.value == "") {
        email_el.style.borderColor = "red";
      } else if (username_el.value == "") {
        username_el.style.borderColor = "red";
      } else {
        // On créer et on le selectionne automatiquement
        this.username = username_el.value;
        this.email = email_el.value;
        let query = "http://localhost:4000/api/users/";

        axios
          .post(query, {
            username: this.username,
            email: this.email
          })
          .then(() => {
            this.getUser();
          })
          .catch(err => {
            const code = parseInt(("" + err).split("code ")[1].substring(0, 3));
            if (code === 422) {
              this.error = "This user already exist";
            }
          });
      }
    }
  }
};
</script>

<style lang="scss">
header {
  background-color: #67899a;
  height: 100px;
}
.error {
  color: red;
}
.center-card {
  display: flex;
  flex-direction: column;
  position: absolute;
  width: 400px;
  height: 300px;
  background-color: white;
  top: 50%;
  right: 50%;
  transform: translate(50%, -50%);
  border-radius: 3px;
  padding: 20px;
  box-shadow: 0px 0 20px 0 rgba(172, 183, 213, 0.2);
  & h1 {
    margin: 0 auto;
    font-size: 26px;
    width: 300px;
    text-align: center;
    color: #32292f;
    border-left: 3px solid #575366;
  }
  & .center-form {
    margin-top: 30px;
    display: flex;
    flex-direction: column;
    & .card-input {
      margin: 0 auto 30px auto;
      width: 300px;
    }
  }
  & .form-buttons {
    width: 60%;
    margin: 0 auto;
    display: flex;
    justify-content: space-around;
  }
  & .button-classic {
    width: 80px;
    padding: 5px 10px;
    border: none;
    background-color: #7484b4;
    color: white;
  }
  & .card-form-error {
    margin-top: 10px;
  }
}

.header-contents {
  height: 100%;
  width: 100%;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  .left {
    .username-container {
      padding: 5px 20px;
      background-color: rgb(200, 214, 212);
      box-shadow: 0px 0 5px 0 rgba(200, 214, 212, 0.2);
      display: flex;
      border-radius: 100px;
      & .username {
        font-size: 18px;
      }
    }
  }
  .center {
    transform: translate(-50%, -25%);
    .today-container {
      .today {
        font-size: 18px;
        color: white;
        font-size: 22px;
      }
    }
  }
  .right {
    position: relative;
    & #settings-btn {
      position: relative;
      background-color: rgba(255, 255, 255, 0);
      padding: 5px 20px;
      z-index: 2;
      padding-left: 0;
      width: 120px;
      height: 32px;
      outline: none;
      display: flex;
      border-radius: 100px;
      border: none;
      &:not(.settingActive) {
        & .img-container {
          position: absolute;
          top: 50%;
          transform: translateY(-50%);
          padding-right: 85px;
          padding-left: 10px;
          height: 32px;
          width: 120px;
          background-color: rgb(224, 224, 224);
          border-radius: 100px;
          transition: 0.7s all ease;
          display: flex;
          right: 1px;
          z-index: 0;
          & img {
            animation: spin 5s;
            width: 30px;
            margin: auto;
          }
        }

        &::before {
          transition: 2s all;
          z-index: 2;
          width: 100%;
          height: 100%;
          padding-left: 40px;
          font-weight: 700;
          color: #252525;
          opacity: 1;
          content: "Settings";
          font-size: 15px;
        }
        &:hover {
          &::before {
            transition: 0.2s all;
            opacity: 0;
          }
          & .img-container {
            right: 1;
            padding: 0;
            width: 30px;
            & img {
              animation: spin 1s;
            }
          }
        }
        &:not(:hover) {
          & .img-container {
            & img {
              animation: reverse-spin 1s;
            }
          }
        }
      }
      &.settingActive {
        margin: 0;
        padding: 0;
        &::before {
          transition: 2s all;
          opacity: 0;
          font-weight: 700;
          color: #252525;
          font-size: 15px;
          content: "Settings";
        }
        & .img-container {
          right: 0;
          padding: 0;
          top: 50%;
          transform: translateY(-50%);
          height: 32px;
          width: 120px;
          position: absolute;
          background-color: rgb(224, 224, 224);
          border-radius: 100px;
          display: flex;
          & img {
            animation: back-arrow-appear 0.4s;
            width: 30px;
            margin: auto;
          }
          right: 0;
          padding: 0;
          width: 40px;
        }
      }
    }
    & .setting-dropdown {
      position: absolute;
      top: 35px;
      background-color: rgb(224, 224, 224);
      border-radius: 10px;
      width: 120px;
      box-shadow: 0px 0 10px 0 rgba(92, 92, 92, 0.2);
      & h2 {
        margin-top: 10px;
        font-size: 20px;
        font-weight: 800;
      }
      & ul {
        list-style: none;
        padding: 0;
        margin: 0;
        & li {
          cursor: pointer;
          color: rgb(39, 39, 39);
          border-top: 1px solid rgba(163, 163, 163, 0.2);
          padding: 7px 0;
          &:hover {
            font-weight: bold;
            opacity: 0.9;
          }
          &#create {
            background-color: #a0d4c0d5;
          }
          &#delete {
            background-color: #d4a2a0d8;
          }
        }
      }
    }
  }
}

.header-form {
  display: flex;
  position: absolute;
  align-items: center;
  justify-content: space-between;
  right: 70px;
  height: 100%;
  animation: form-appear 0.7s ease-out;
  &#deleteForm {
    background-color: rgb(224, 224, 224);
    padding: 20px 20px;
    border-radius: 10px;
    margin-top: -5px;
    & label {
      font-size: 18px;
      margin: 0;
      font-weight: 800;
      color: rgb(54, 46, 46);
    }
    & button {
      background-color: #d4a2a0d8;
      font-weight: bold;
    }
    width: 180px;
  }
  & button {
    z-index: 5;
    transition: 0.25s all;
    border: none;
    border-radius: 5px;
    padding: 2px 10px;
    &:hover {
      opacity: 0.5;
    }
  }
}

@-moz-keyframes spin {
  100% {
    -moz-transform: rotate(360deg);
  }
}
@-webkit-keyframes spin {
  100% {
    -webkit-transform: rotate(360deg);
  }
}
@keyframes spin {
  100% {
    transform: rotate(360deg);
  }
}

@keyframes reverse-spin {
  100% {
    transform: rotate(-360deg);
  }
}

@keyframes back-arrow-appear {
  0% {
    opacity: 0.5;
    transform: rotate(-120deg);
  }
  100% {
    opacity: 1;
    transform: rotate(0deg);
  }
}

@keyframes form-appear {
  0% {
    opacity: 0;
    position: absolute;
    right: -50px;
  }
  100% {
    opacity: 1;
    right: 70px;
  }
}
</style>