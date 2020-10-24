<template>
  <header>

    <div>
      <b-navbar toggleable="lg" type="dark" variant="info">
        <b-navbar-brand >TimeManager</b-navbar-brand>

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
          <b-navbar-nav>
            <b-nav-item>Horaires</b-nav-item>
            <b-nav-item >Agenda</b-nav-item>
          </b-navbar-nav>
          <b-navbar-nav class="ml-auto">
       <div >
          <b-form inline>
            <label class="sr-only" for="inline-form-input-name">Name</label>
            <b-input
              id="inline-form-input-username"
              class="mb-2 mr-sm-2 mb-sm-0"
              placeholder="Username"
            ></b-input>

            <label class="sr-only" for="inline-form-input-username"
              >Username</label
            >
            <b-input-group prepend="@" class="mb-2 mr-sm-2 mb-sm-0">
              <b-input
                id="inline-form-input-email"
                placeholder="Email"
              ></b-input>
            </b-input-group>

            <b-button v-on:click="getUser()" variant="primary"
              >GetUser</b-button
            >
            <b-button v-on:click="createUser()" variant="primary"
              >CreateUser</b-button
            >
            
          </b-form>
        </div>
            <b-nav-item-dropdown v-if="!isHidden" right>
              <template #button-content>
                <em >%{username}</em>
              </template>
              <b-dropdown-item v-on:click="updateUser()">Update profile</b-dropdown-item>
              <b-dropdown-item v-on:click="deleteUser()">Delete profile</b-dropdown-item>
              <b-dropdown-item v-on:click="logout()" >Sign Out</b-dropdown-item>
            </b-nav-item-dropdown>
          </b-navbar-nav>
        </b-collapse>
      </b-navbar>
    </div>
    <div v-if="!userID" class="center-card">
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
Vue.use(VueAxios, axios);

export default {
  data: function() {
    return {
      userID: null,
      username: "",
      email: "",
      isHidden: true,
      error: null
    };
  },
  methods: {
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
            if (user) {
              this.isHidden = false;
              this.username = user.username;
              this.email = user.email;
              this.userID = user.id;
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
      let query = "http://localhost:4000/api/users/" + this.userID;
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
      if (!this.userID) {
        alert("Cannot delete unselected user.");
      } else {
        let query = "http://localhost:4000/api/users/" + this.userID;
        axios.delete(query).then(() => {
          this.$store.dispatch("change", null);
          this.userID = null;
          this.email = null;
          this.username = null;
          this.isHidden = true;
        });
        alert("User " + this.username + " deleted.");
      }
    },

    logout: function() {
      localStorage.userID = null;
      this.isHidden = true;
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
  background-color: #575366;
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
</style>