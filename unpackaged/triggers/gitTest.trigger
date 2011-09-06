trigger gitTest on Account (after update) {
for (Account myAccount : trigger.New){
	system.debug('gitTest');
	system.debug('hi nancy');
	//where does this go
}
}