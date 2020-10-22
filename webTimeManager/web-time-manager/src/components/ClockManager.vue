<template>
  <div class="clocks">
    <h1>Clock</h1>

    <div>
      <div>
        <div class="status clock-infos">
          <span class="span-head">Work in progress :</span>
          <span class="span-info">{{ clockIn ? "Yes" : "No" }}</span>
        </div>
        <div v-if="clockIn" class="start-date clock-infos">
          <span class="span-head">Start : </span>
          <span class="span-info">{{ startDateTime }}</span>
        </div>
      </div>
      <b-button class="mt-3" variant="primary" @click="clock()">Clock</b-button>
    </div>
    <div id="data-list" class="panel panel-default" v-if="data && data.length">
      <table class="table">
        <tr>
          <th scope="col">Start</th>
          <th scope="col">In Progress</th>
          <th scope="col">End</th>
        </tr>
        <tbody>
          <tr
            class="element-tr"
            v-for="element in data"
            v-bind:key="element.id"
          >
            <td>{{ element.start }}</td>
            <td>{{ element.status ? "Yes" : "No" }}</td>
            <td>{{ element.end }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-else class="no-data">
      No data to display
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: function() {
    return {
      data: null,
      startDateTime: null,
      clockIn: false,
      userId: 2
    };
  },
  created: function() {
    this.getClocks();
  },
  methods: {
    clock() {
      this.clockIn = !this.clockIn;
      const clock = { time: new Date(), status: this.clockIn };

      axios
        .post(`http://localhost:4000/api/clocks/${this.userId}`, clock)
        .then(() => {
          clock.time = this.formatDate(clock.time);
          this.startDateTime = clock.time;
          if (!this.clockIn) {
            this.data[0].status = false;
            this.data[0].end = clock.time;
          } else {
            this.data.unshift({ start: clock.time, status: true });
          }
          console.log(this.clockIn);
        });
    },
    getClocks() {
      axios
        .get(`http://localhost:4000/api/clocks/${this.userId}`)
        .then(res => {
          const clocks = res?.data?.data;
          const lastClock = clocks[clocks.length - 1] || { status: false };
          this.startDateTime = lastClock.time.split("T").join(" ");
          this.clockIn = lastClock.status;
          this.data = [];
          for (let i = 0; i < clocks.length; i += 2) {
            const clock = { start: clocks[i].time.split("T").join(" ") };
            const nextExist = i < clocks.length - 1;
            clock.status = !nextExist;
            clock.end = nextExist
              ? clocks[i + 1].time.split("T").join(" ")
              : null;
            this.data.unshift(clock);
          } 
        })
        .catch(err => console.log(err));
    },
    formatDate(date) {
      const year = date.getFullYear();
      let month = date.getMonth() + 1;
      month = month > 9 ? month : "0" + month;
      let day = date.getDate();
      day = day > 9 ? day : "0" + day;
      let hours = date.getHours();
      hours = hours > 9 ? hours : "0" + hours;
      let minutes = date.getMinutes();
      minutes = minutes > 9 ? minutes : "0" + minutes;
      let seconds = date.getSeconds();
      seconds = seconds > 9 ? seconds : "0" + seconds;
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
  }
};
</script>

<style lang="scss">
.clocks {
  margin-top: 3%;
  display: flex;
  flex-direction: column;
  & .clock-infos {
    display: flex;
    justify-content: center;
    & .span-head {
      margin-top: 10px;
      font-size: 25px;
      font-weight: bold;
      text-decoration: underline;
    }
    & .span-info {
      margin-top: 10px;
      margin-left: 10px;
      font-size: 25px;
      font-style: italic;
    }
  }
  & .get-button {
    display: flex;
    width: 20%;
    margin: 0 auto;
    justify-content: space-around;
  }
  & #data-list {
    margin-top: 20px;
    display: flex;
    & table {
      width: 50%;
      margin: 0 auto;
      list-style: none;
      border-radius: 4px;
      & th {
        border: none !important;
      }
    }
  }
  & .no-data {
    margin-top: 20px;
    font-weight: bold;
    font-size: 20px;
  }
}
</style>