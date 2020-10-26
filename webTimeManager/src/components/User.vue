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
        <HeaderSettings
          :error="error"
          :username="username"
          :email="email"
          :users="users"
          :queryOk="queryOk"
          :queryError="queryError"
          v-on:create="createUser($event.username, $event.email)"
          v-on:update="updateUser($event.username, $event.email)"
          v-on:searchUsers="searchUsers($event)"
          v-on:change="changeUser($event)"
          v-on:delete="deleteUser()"
          v-on:resetError="error = null"
        />
      </div>
    </div>

    <div v-else class="center-card">
      <h1>Select or Create a user</h1>
      <b-form class="center-form" v-on:submit.prevent="getUser()">
        <label class="sr-only" for="form-input-name">Name</label>
        <b-input
          class="card-input"
          id="form-input-username"
          placeholder="Username"
        ></b-input>

        <label class="sr-only" for="form-input-username">Username</label>
        <b-input-group prepend="@" class="card-input">
          <b-input id="form-input-email" placeholder="Email"></b-input>
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
import HeaderSettings from "./HeaderSettings";

Vue.use(VueAxios, axios);

export default {
  data: function() {
    return {
      userId: 1,
      username: null,
      email: null,
      error: null,
      today: moment().format("LL"),
      users: null,
      queryOk: true,
      queryError: false
    };
  },
  components: {
    HeaderSettings
  },
  methods: {
    documentGet: function(value) {
      return document.getElementById(`form-input-${value}`);
    },
    validEmail: function(email) {
      const regex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return regex.test(email);
    },
    checkField: function(input, fieldError, method = null) {
      if ((method && !method(input.value)) || !input.value) {
        fieldError.value = true;
        input.style.borderColor = "#d68582d8";
        input.style.borderWidth = "2px";
      } else {
        input.style.borderColor = null;
        input.style.borderWidth = "1px";
      }
    },
    initUser: function(user) {
      this.isHidden = false;
      this.username = user.username;
      this.email = user.email;
      this.userId = user.id;
      this.$store.dispatch("change", user.id);
      if (this.$router.history.current.path !== "/dashboard") {
        this.$router.push("/dashboard");
      }
    },
    getUser: function(username = null, email = null) {
      const usernameInput = username || this.documentGet("username");
      const emailInput = email || this.documentGet("email");
      const fieldError = { value: false };
      this.checkField(usernameInput, fieldError);
      this.checkField(emailInput, fieldError, this.validEmail);
      if (fieldError.value) {
        this.queryOk = true;
        this.queryError = true;
      } else {
        let query = `http://localhost:4000/api/users?username=${usernameInput.value}&email=${emailInput.value}`;
        axios
          .get(query)
          .then(response => {
            const user = response.data.data;
            if (user) {
              this.initUser(user);
            } else {
              console.log("User not found");
            }
          })
          .catch(error => console.log(error));
      }
    },

    updateUser: function(username = null, email = null) {
      this.queryOk = false;
      const usernameInput = username || this.documentGet("username");
      const emailInput = email || this.documentGet("email");
      const fieldError = { value: false };
      this.checkField(usernameInput, fieldError);
      this.checkField(emailInput, fieldError, this.validEmail);
      if (fieldError.value) {
        this.queryOk = true;
        this.queryError = true;
      } else {
        let query = "http://localhost:4000/api/users/" + this.userId;
        axios
          .put(query, {
            username: usernameInput.value,
            email: emailInput.value
          })
          .then(() => {
            this.queryOk = true;
            this.queryError = false;
            this.username = usernameInput.value;
            this.email = emailInput.value;
          })
          .catch(err => {
            this.queryOk = true;
            this.queryError = true;

            const code = parseInt(("" + err).split("code ")[1].substring(0, 3));
            if (code === 422) {
              this.error = "This user already exist";
            }
          });
      }
    },
    searchUsers: function(value) {
      if (value) {
        this.queryOk = false;
        const query = `http://localhost:4000/api/users/list/get?match=${value}`;
        axios.get(query).then(res => {
          this.queryOk = true;
          this.queryError = false;
          this.users = res.data.data.filter(_ => _.id !== this.userId);
        });
      } else {
        this.users = null;
      }
    },
    deleteUser: function() {
      this.queryOk = false;
      const query = "http://localhost:4000/api/users/" + this.userId;
      axios
        .delete(query)
        .then(() => {
          this.$store.dispatch("change", null);
          this.userId = null;
          this.email = null;
          this.username = null;
          this.isHidden = true;
          this.queryOk = true;
          this.queryError = false;
        })
        .catch(err => console.log(err));
    },

    logout: function() {
      this.userId = null;
      this.isHidden = true;
      this.$store.dispatch("change", null);
    },
    changeUser: function(user) {
      this.users = null;
      this.initUser(user);
    },

    createUser: function(username = null, email = null) {
      this.queryOk = false;
      const usernameInput = username || this.documentGet("username");
      const emailInput = email || this.documentGet("email");
      const fieldError = { value: false };
      this.checkField(usernameInput, fieldError);
      this.checkField(emailInput, fieldError, this.validEmail);
      if (fieldError.value) {
        this.queryOk = true;
        this.queryError = true;
      } else {
        let query = "http://localhost:4000/api/users/";
        axios
          .post(query, {
            username: usernameInput.value,
            email: emailInput.value
          })
          .then(res => {
            this.queryOk = true;
            this.queryError = false;
            this.initUser(res.data.data);
          })
          .catch(err => {
            this.queryOk = true;
            this.queryError = true;
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
  z-index: 10;
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
  position: relative;

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
    position: absolute;
    right: 50%;
    transform: translate(50%, -25%);
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
  }
}
</style>