<template>
  <header>
    <div class="user" style="margin-top:3%;" >
      <div  style="display:flex;justify-content:start;">
        <div style="margin-left: 1%;padding-right:1%;">

          <b-form inline>
          <label class="sr-only" for="inline-form-input-name">Name</label>
          <b-input
            id="inline-form-input-username"
            class="mb-2 mr-sm-2 mb-sm-0"
            placeholder="Username"            
          ></b-input>

          <label class="sr-only" for="inline-form-input-username">Username</label>
          <b-input-group prepend="@" class="mb-2 mr-sm-2 mb-sm-0">
            <b-input id="inline-form-input-email" placeholder="email"></b-input>
          </b-input-group>

          <b-button v-on:click="getUser()" variant="primary">GetUser</b-button>    
        </b-form>

      <b-card
        border-variant="secondary"
        header="Secondary"
        header-border-variant="secondary"
        align="center">
        <b-card-text>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</b-card-text>
      </b-card>

        </div>

        <div style="padding-right:1%;">
          <b-button v-on:click="updateUser()" v-if="!isHidden" variant="outline-info" >UpdateUser</b-button>
        </div>

        <div style="padding-right:1%;">
          <b-button v-on:click="deleteUser()" v-if="!isHidden" variant="outline-danger" >DeleteUser</b-button>
        </div>
        <div style="padding-right:1%;">
          <b-button class="delUser" v-on:click="createUser()" variant="outline-primary" >CreateUser</b-button>
        </div>
      </div>    
    </div>
  </header>
</template>

<script>
import axios from 'axios'
import VueAxios from 'vue-axios'
import Vue from 'vue'
Vue.use(VueAxios,axios)

export default {
  data: function(){
    return {
      userID: 0,
      username: '',
      email: '',
      isHidden: true
    }
  },
  created: function() {
},
  methods: {
    getUser: function()
    {
      let username_el = document.getElementById('inline-form-input-username');
      let email_el = document.getElementById('inline-form-input-email');

      if(username_el.value == "" && email_el.value == ""){
        // Changer les couleurs des inputs
        email_el.style.borderColor = "red";
        username_el.style.borderColor = "red";
      }else if(email_el.value == "") {
        email_el.style.borderColor = "red";
      }else if(username_el.value == ""){
        username_el.style.borderColor = "red";
      }else {
        let query = 'http://localhost:4000/api/users?username='+username_el.value+'&email='+email_el.value;
        axios.get(query).then((response) => {
        console.log(response.data);
        localStorage.userID = response.data.data.id;
        }).catch(error => console.log(error));
        this.isHidden = !this.isHidden;
      }
    },

    updateUser: function() {
        let username_el = document.getElementById('inline-form-input-username');
        let email_el = document.getElementById('inline-form-input-email');
        let query = 'http://localhost:4000/api/users/'+localStorage.userID;
        axios.put(query,{
          username: username_el.value,
          email: email_el.value
        }).then((response) => {
        console.log(response.data);});
    },

    deleteUser: function() {
      if (localStorage.userID == ''){
        alert('Cannot delete unselected user.');
      } else {
        let query = 'http://localhost:4000/api/users/'+localStorage.userID;
        axios.delete(query).then((response) => {
        console.log(response.data);
        localStorage.userID = '';
        this.isHidden=true;});
        alert('User ' + this.username + ' deleted.');   
      }
    },

    createUser: function(){
      let username_el = document.getElementById('inline-form-input-username');
      let email_el = document.getElementById('inline-form-input-email');
      
      if(username_el.value == "" && email_el.value == ""){
        // Changer les couleurs des inputs
        email_el.style.borderColor = "red";
        username_el.style.borderColor = "red";
      }else if(email_el.value == "") {
        email_el.style.borderColor = "red";
      }else if(username_el.value == ""){
        username_el.style.borderColor = "red";
      }else {
        // On créer et on le selectionne automatiquement
        this.username = username_el.value;
        this.email = email_el.value;        
        let query = 'http://localhost:4000/api/users/';
        
        axios.post(query,{
          username: this.username,
          email: this.email
        }).then((response) => {
          console.log(response.data);
          this.getUser();
        }); 
        }
    }
  }
}
</script>