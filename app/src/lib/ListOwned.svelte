<script lang='ts'>
import { Card } from 'flowbite-svelte';

export let ownedList = [];
</script>

<Card>
<h3>Owned Aspects</h3>
<ul>
    {#each ownedList as ownedAspect}
    <li>{ownedAspect.note} - {ownedAspect.time}</li>
    {/each}
</ul>
</Card>
