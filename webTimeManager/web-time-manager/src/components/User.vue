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
                placeholder="email"
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
      isHidden: true
    };
  },
  created: function() {
    
    this.isHidden = localStorage.getItem("userID") == "null";
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
              localStorage.userID = user.id;
            } else {
              console.log("User not found");
            }
          })
          .catch(error => console.log(error));
        if (this.$router.history.current.path !== "/") {
          this.$router.push("/");
        }
      }
    },

    updateUser: function() {
      let username_el = document.getElementById("inline-form-input-username");
      let email_el = document.getElementById("inline-form-input-email");
      let query = "http://localhost:4000/api/users/" + localStorage.userID;
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
      if (localStorage.userID == "") {
        alert("Cannot delete unselected user.");
      } else {
        let query = "http://localhost:4000/api/users/" + localStorage.userID;
        axios.delete(query).then(() => {
          localStorage.userID = null;
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
          });
      }
    }
  }
};
</script>