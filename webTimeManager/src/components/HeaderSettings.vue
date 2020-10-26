<template>
  <div class="header-settings">
    <b-form
      v-bind:class="{ formActive: settingActive && createForm }"
      id="createForm"
      class="header-form"
      v-on:submit.prevent="mainFormUser('create')"
    >
      <b-input
        class="header-form-input"
        id="inline-create-form-input-username"
        placeholder="Username"
      ></b-input>
      <b-input-group prepend="@" class="header-form-input">
        <b-input
          id="inline-create-form-input-email"
          placeholder="Email"
        ></b-input>
      </b-input-group>
      <div class="form-buttons">
        <button type="submit" v-bind:class="{ loading: !queryOk }">
          <span v-if="queryOk">Create</span>
          <span v-else class="loader"></span>
        </button>
      </div>
      <span class="error">{{ error }}</span>
    </b-form>

    <div
      v-bind:class="{ formActive: settingActive && changeForm }"
      id="changeForm"
      class="header-form"
    >
      <AutoCompleteField
        placeholder="Enter a username or an email"
        :dataToSelect="users"
        :queryOk="queryOk"
        keyToShow="username"
        v-on:searchUsers="searchUsers($event)"
        v-on:dataSelected="changeUser($event)"
      />
    </div>

    <b-form
      v-bind:class="{ formActive: settingActive && updateForm }"
      id="updateForm"
      class="header-form"
      v-on:submit.prevent="mainFormUser('update')"
    >
      <b-input
        class="header-form-input"
        id="inline-update-form-input-username"
        :value="username"
        placeholder="Username"
      ></b-input>
      <b-input-group prepend="@" class="header-form-input">
        <b-input
          id="inline-update-form-input-email"
          :value="email"
          placeholder="Email"
        ></b-input>
      </b-input-group>
      <div class="form-buttons">
        <button type="submit" v-bind:class="{ loading: !queryOk }">
          <span v-if="queryOk">Update</span>
          <span v-else class="loader"></span>
        </button>
      </div>
      <span class="error">{{ error }}</span>
    </b-form>

    <div
      v-bind:class="{ formActive: settingActive && deleteForm }"
      id="deleteForm"
      class="header-form"
    >
      <label for="">Confirm ?</label>
      <button @click="deleteUser()" v-bind:class="{ loading: !queryOk }">
        <span v-if="queryOk">Yes</span>
        <span v-else class="loader"></span>
      </button>
    </div>

    <button
      id="settings-btn"
      v-bind:class="{
        settingActive: settingActive,
        dropDownActive: dropDownActive
      }"
      @mouseover="activeDropDown(true)"
      @mouseleave="activeDropDown(false)"
      @click="clickBack"
    >
      <div class="img-container">
        <img v-if="!settingActive" src="../assets/icons/settings.svg" />
        <img v-if="settingActive" src="../assets/icons/back-arrow.svg" alt="" />
      </div>
    </button>
    <div
      v-bind:class="{ displayDropDown: dropDownActive }"
      @mouseover="activeDropDown(true)"
      @mouseleave="activeDropDown(false)"
      class="setting-dropdown"
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
</template>


<script>
import AutoCompleteField from "./AutoCompleteField";

export default {
  data: function() {
    return {
      settingActive: false,
      dropDownActive: false,
      createForm: false,
      updateForm: false,
      changeForm: false,
      deleteForm: false,
      mouseOnDropDown: false
    };
  },
  components: {
    AutoCompleteField
  },
  props: ["username", "email", "error", "users", "queryOk", "queryError"],
  watch: {
    queryOk: function(val) {
      this.queryOk = val;
      setTimeout(() => {
        if (val && !this.queryError && !this.changeForm) {
          this.deactivateForms();
          this.settingActive = false;
        }
      }, 100);
    }
  },
  methods: {
    deactivateForms: function() {
      for (const type of ["create", "update", "change", "delete"]) {
        this[`${type}Form`] = false;
      }
    },
    clickBack: function() {
      this.settingActive = false;
      this.dropDownActive = true;
      this.deactivateForms();
      this.$emit("resetError");
    },
    activeDropDown: function(value) {
      if (!this.settingActive) {
        this.mouseOnDropDown = value;
        if (value) {
          this.dropDownActive = value;
        } else {
          setTimeout(() => {
            this.dropDownActive = this.mouseOnDropDown;
          }, 100);
        }
      }
    },
    activateSetting: function() {
      if (!this.formActive()) {
        this.settingActive = !this.settingActive;
        this.dropDownActive = this.settingActive;
      } else {
        this.settingActive = true;
        this.dropDownActive = true;
      }
    },
    formActive: function() {
      return (
        this.createForm || this.updateForm || this.changeForm || this.deleteForm
      );
    },
    display: function(type) {
      this.dropDownActive = false;
      this.settingActive = true;
      this[`${type}Form`] = true;
    },
    resetSettings: function(form) {
      if (!this.error) {
        this[form] = false;
        this.settingActive = false;
      }
    },
    mainFormUser: function(event) {
      if (this.queryOk) {
        let username = document.getElementById(
          `inline-${event}-form-input-username`
        );
        let email = document.getElementById(`inline-${event}-form-input-email`);
        this.$emit(event, { username, email });
      }
    },
    searchUsers: function(value) {
      this.$emit("searchUsers", value);
    },
    changeUser: function(value) {
      this.$emit("change", value);
      this.changeForm = false;
      this.settingActive = false;
    },
    deleteUser: function() {
      if (this.queryOk) {
        this.$emit("delete");
      }
    },
    logout: function() {
      this.$emit("logout");
    }
  }
};
</script>

<style lang="scss">
.header-settings {
  position: relative;
  float: right;
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
      &.dropDownActive {
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
      &:not(.dropDownActive) {
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
    transition: all 0.2s;
    position: absolute;
    top: 35px;
    background-color: rgb(224, 224, 224);
    border-radius: 10px;
    width: 120px;
    box-shadow: 0px 0 10px 0 rgba(92, 92, 92, 0.2);
    pointer-events: none;
    opacity: 0;
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
    &.displayDropDown {
      pointer-events: all;
      opacity: 1;
    }
  }
}

.header-form {
  display: flex;
  position: absolute;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  right: 50px;
  opacity: 0;
  right: -50px;
  pointer-events: none;
  transition: all 0.3s ease-in;
  z-index: 1;
  &.formActive {
    transition: all 0.4s ease-out;
    z-index: 6;
    opacity: 1;
    right: 50px;
    pointer-events: all;
  }
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
      background-color: #c27976d8;
    }
    width: 230px;
  }
  &#createForm {
    width: 500px;
    & button {
      background-color: #a0d4c0d5;
    }
  }
  &#updateForm {
    width: 500px;
    & button {
      background-color: #cfd4a0d5;
    }
  }
  &#changeForm {
    width: 250px;
  }
  & button {
    font-weight: bold;
    z-index: 6;
    transition: 0.25s all;
    border: none;
    border-radius: 5px;
    padding: 2px 10px;
    width: 80px;
    height: 35px;
    &.loading {
      & .loader {
        display: inline-block;
        width: 20px;
        height: 20px;
        margin-top: 5px;
        &:after {
          content: "";
          display: block;
          width: 20px;
          height: 20px;
          border-radius: 50%;
          border: 2px solid #32292f;
          border-color: #32292f transparent #32292f transparent;
          animation: lds-dual-ring 1.2s linear infinite;
        }
      }
      &:hover {
        cursor: wait !important;
        opacity: 1 !important;
      }
    }
    &:hover {
      opacity: 0.5;
    }
  }
  & .header-form-input {
    width: 200px;
  }
  & .error {
    color: red;
    position: absolute;
    bottom: -30px;
    right: 50%;
    font-weight: bold;
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

@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>