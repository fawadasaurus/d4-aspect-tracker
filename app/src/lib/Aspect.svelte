<script lang='ts'>
    import { Card } from 'flowbite-svelte';
    import AddOwned  from './AddOwned.svelte';
    import ListOwned  from './ListOwned.svelte';
  
    export let aspect;
    export let ownedList = [];
</script>
  
<Card class="w-96">
    <h3 class="text-2xl font-bold mb-2">{aspect.name}</h3>
    <p class="text-base mb-4">{aspect.desc}</p>
  
    <div class="flex">
      <div class="w-1/2 pr-4">
        <ListOwned aspectName={aspect.name} ownedList={ownedList} on:aspectUpdated />
      </div>
      <div class="w-1/2">
        <AddOwned aspectName={aspect.name} on:aspectUpdated />
      </div>
    </div>
  </Card>