<template>
  <header>
    <div class="user" style="margin-top:3%;" >
      <div  style="display:flex;justify-content:start;">
        <div style="margin-left: 1%;padding-right:1%;">
          <b-form inline>
          <label class="sr-only" for="inline-form-input-name">Name</label>
          <b-input
            id="inline-form-input-name"
            class="mb-2 mr-sm-2 mb-sm-0"
            placeholder="Username"
          ></b-input>

          <label class="sr-only" for="inline-form-input-username">Username</label>
          <b-input-group prepend="@" class="mb-2 mr-sm-2 mb-sm-0">
            <b-input id="inline-form-input-username" placeholder="email"></b-input>
          </b-input-group>

          <b-button v-on:click="getUser()" variant="primary">GetUser</b-button>    
        </b-form>  
        </div>

        <div style="padding-right:1%;">
          <b-button v-on:click="updateUser()" variant="outline-primary" >UpdateUser</b-button>
        </div>

        <div style="padding-right:1%;">
          <b-button v-on:click="deleteUser()" variant="outline-primary" >DeleteUser</b-button>
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
  
  methods: {
    getUser: function()
    {
      //var username = document.getElementById("inline-form-input-name").value;
      //var email = document.getElementById("inline-form-input-username").value;
      return axios.get('localhost://4000/1');
    },

    updateUser: function() {
      
    },

    deleteUser: function() {

    },

    createUser: function(){

    }
  }
}
</script>