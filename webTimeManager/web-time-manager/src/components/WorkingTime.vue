<template>
  <div v-if="selectedWorkingTime" class="WorkingTime" style="margin-top:3%;">
    <div class="create-button-div">
      <b-button variant="primary" @click.stop="onCreateClick">
        Create
      </b-button>
      <div v-if="displayCreate" class="card create-card" v-on:click.stop>
        <DateForm v-on:submit="createWorkingTime($event)" submitText="Create" />
      </div>
    </div>
    <div class="times">
      <span>Start : {{ selectedWorkingTime.start }}</span>
      <span>End : {{ selectedWorkingTime.end }}</span>
      <span>Total Working Time : {{ selectedWorkingTime.time }}</span>
    </div>
    <div class="buttons">
      <div>
        <b-button variant="primary" @click.stop="onUpdateClick">
          Update
        </b-button>
        <div v-if="displayUpdate" class="card update-card" v-on:click.stop>
          <DateForm
            v-on:submit="updateWorkingTime($event)"
            submitText="Update"
            v-bind:prevalue="selectedWorkingTime"
          />
        </div>
      </div>
      <div>
        <b-button variant="danger" @click.stop="onDeleteClick">
          Delete
        </b-button>
        <div v-if="displayDelete" class="card delete-card" v-on:click.stop>
          <h3>Are you sure ?</h3>
          <div class="delete-buttons">
            <b-button variant="danger" @click="deleteWorkingTime">Yes</b-button>
            <b-button variant="outline-primary" @click="displayDelete = false"
              >No</b-button
            >
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateForm from "./DateForm";
import axios from "axios";

export default {
  data: function() {
    return {
      displayUpdate: false,
      displayDelete: false,
      displayCreate: false,
      selectedWorkingTime: null,
      userId: 2
    };
  },
  props: ["workingTime"],
  components: {
    DateForm
  },
  created: function() {
    if (!this.workingTime) {
      this.$router.push({ name: "WorkingTimes" });
    } else {
      this.selectedWorkingTime = this.workingTime;
    }
  },
  mounted() {
    document.addEventListener("click", this.closeDropDown);
  },
  methods: {
    updateWorkingTime: function(event) {
      axios
        .put(
          `http://localhost:4000/api/workingtimes/${this.selectedWorkingTime.id}`,
          event
        )
        .then(() => {
          this.selectedWorkingTime = {
            start: this.formatDate(event.start),
            end: this.formatDate(event.end),
            id: this.selectedWorkingTime.id,
            time: this.calcTime(event)
          };
          console.log(this.selectedWorkingTime);
          this.displayUpdate = false;
        })
        .catch(err => console.log(err));
    },
    createWorkingTime: function(event) {
      axios
        .post(`http://localhost:4000/api/workingtimes/${this.userId}`, event)
        .then(res => {
          this.selectedWorkingTime = {
            ...event,
            id: res.id,
            time: this.calcTime(event)
          };
          this.displayCreate = false;
        })
        .catch(err => console.log(err));
    },
    deleteWorkingTime: function() {
      axios
        .delete(`http://localhost:4000/api/workingtimes/${this.workingTime.id}`)
        .then(() => {
          this.$router.push({ name: "WorkingTimes" });
        })
        .catch(err => console.log(err));
    },
    calcTime(data) {
      const date1 = new Date(data.start).getTime();
      const date2 = new Date(data.end).getTime();
      const ms = date2 - date1;
      const totalMinutes = Math.floor(ms / 60000);
      let hours = Math.floor(totalMinutes / 60);
      hours = hours > 9 ? hours : "0" + hours;
      let minutes = totalMinutes % 60;
      minutes = minutes > 9 ? minutes : "0" + minutes;
      return `${hours}h${minutes}`;
    },
    formatDate(dateAndTime) {
      dateAndTime = dateAndTime.split(" ");
      console.log(dateAndTime);
      const date = dateAndTime[0]
        .split("-")
        .reverse()
        .join("/");
      const splitTime = dateAndTime[1].split(":");
      const time = `${splitTime[0]}:${splitTime[1]}`;
      return `${date} at ${time}`;
    },
    closeDropDown() {
      this.displayUpdate = false;
      this.displayDelete = false;
      this.displayCreate = false;
    },
    onUpdateClick() {
      this.displayCreate = false;
      this.displayDelete = false;
      this.displayUpdate = !this.displayUpdate;
    },
    onDeleteClick() {
      this.displayCreate = false;
      this.displayUpdate = false;
      this.displayDelete = !this.displayDelete;
    },
    onCreateClick() {
      this.displayDelete = false;
      this.displayUpdate = false;
      this.displayCreate = !this.displayCreate;
    }
  }
};
</script>

<style lang="scss">
.create-button-div {
  width: 100px;
  margin: auto;
  margin-bottom: 50px;
}
.times {
  display: flex;
  flex-direction: column;
  & span {
    margin-bottom: 10px;
    font-size: 20px;
  }
}
.buttons {
  margin: 20px auto;
  width: 15%;
  display: flex;
  justify-content: space-between;
}
.card {
  margin-top: 10px;
  padding: 20px;
  background-color: #fff;
  border: 1px solid rgba(63, 63, 63, 0.219);
  border-radius: 15px;
  position: absolute;
  width: 320px;
  &.update-card {
    transform: translateX(calc(-50% + 26px));
  }
  &.create-card {
    transform: translateX(calc(-50% + 40px));
  }
  &.delete-card {
    transform: translateX(calc(-50% + 30px));
  }
}
.delete-buttons {
  margin: 0 auto;
  height: 40px;
  width: 120px;
  display: flex;
  justify-content: space-between;
}
</style>