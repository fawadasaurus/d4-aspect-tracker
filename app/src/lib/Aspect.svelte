<script lang='ts'>
    import { Card } from 'flowbite-svelte';
    import AddOwned  from './AddOwned.svelte';
    import ListOwned  from './ListOwned.svelte';
  
    export let aspect;
    export let ownedList = [];
</script>
  
  <Card>
    <h3>{aspect.name}</h3>
    <p>{aspect.desc}</p>
  
    <AddOwned aspectName={aspect.name} on:aspectAdded />
    <ListOwned ownedList={ownedList} />
  </Card>