class Analyze {

  String _description, _hashtags, _location;
  int _category;

  analyzeCategory() async {
    var keywords = _description.toLowerCase() + " " + _hashtags.toLowerCase();
    var keywordsArray = keywords.split(' ');
    print(keywordsArray);
    int beach = 0, mountain = 0;

    for (int i = 0; i <= keywordsArray.length; i++) {
      if (keywordsArray[i] == 'beach' ||
          keywordsArray[i] == '#beach' ||
          keywordsArray[i] == 'sea' ||
          keywordsArray[i] == '#sea' ||
          keywordsArray[i] == 'coast' ||
          keywordsArray[i] == '#coast' ||
          keywordsArray[i] == 'seaside' ||
          keywordsArray[i] == '#seaside' ||
          keywordsArray[i] == 'coral' ||
          keywordsArray[i] == '#coral' ||
          keywordsArray[i] == 'island' ||
          keywordsArray[i] == '#island' ||
          keywordsArray[i] == 'fish' ||
          keywordsArray[i] == '#fish' ||
          keywordsArray[i] == 'jellyfish' ||
          keywordsArray[i] == '#jellyfish' ||
          keywordsArray[i] == 'downsouth' ||
          keywordsArray[i] == '#downsouth') {
        _category = 1;
      }
      if (keywordsArray[i] == 'mountain' ||
          keywordsArray[i] == '#mountain' ||
          keywordsArray[i] == 'hill' ||
          keywordsArray[i] == '#hill' ||
          keywordsArray[i] == 'hillside' ||
          keywordsArray[i] == '#hillside' ||
          keywordsArray[i] == 'hike' ||
          keywordsArray[i] == '#hike' ||
          keywordsArray[i] == 'cave' ||
          keywordsArray[i] == '#cave' ||
          keywordsArray[i] == 'climb' ||
          keywordsArray[i] == '#climb' ||
          keywordsArray[i] == 'rock' ||
          keywordsArray[i] == '#rock') {
        _category = 2;
      }
      if (keywordsArray[i] == 'camp' ||
          keywordsArray[i] == '#camp' ||
          keywordsArray[i] == 'fire' ||
          keywordsArray[i] == '#fire' ||
          keywordsArray[i] == 'campfire' ||
          keywordsArray[i] == '#campfire' ||
          keywordsArray[i] == 'tent' ||
          keywordsArray[i] == '#tent' ||
          keywordsArray[i] == 'retreat' ||
          keywordsArray[i] == '#retreat') {
        _category = 3;
      }
      if (keywordsArray[i] == 'waterfall' ||
          keywordsArray[i] == '#waterfall' ||
          keywordsArray[i] == 'river' ||
          keywordsArray[i] == '#river' ||
          keywordsArray[i] == 'lagoon' ||
          keywordsArray[i] == '#lagoon' ||
          keywordsArray[i] == 'stream' ||
          keywordsArray[i] == '#stream' ||
          keywordsArray[i] == 'lake' ||
          keywordsArray[i] == '#lake') {
        _category = 4;
      }
      if (keywordsArray[i] == 'forest' ||
          keywordsArray[i] == '#forest' ||
          keywordsArray[i] == 'wildlife' ||
          keywordsArray[i] == '#wildlife' ||
          keywordsArray[i] == 'wild' ||
          keywordsArray[i] == '#wild' ||
          keywordsArray[i] == 'trees' ||
          keywordsArray[i] == '#trees' ||
          keywordsArray[i] == 'jungle' ||
          keywordsArray[i] == '#jungle' ||
          keywordsArray[i] == 'rainforest' ||
          keywordsArray[i] == '#rainforest') {
        _category = 5;
      }
      if (keywordsArray[i] == 'ancient' ||
          keywordsArray[i] == '#acient' ||
          keywordsArray[i] == 'musieum' ||
          keywordsArray[i] == '#musiem' ||
          keywordsArray[i] == 'histroy' ||
          keywordsArray[i] == '#history' ||
          keywordsArray[i] == 'art' ||
          keywordsArray[i] == '#art' ||
          keywordsArray[i] == 'statue' ||
          keywordsArray[i] == '#statue' ||
          keywordsArray[i] == 'relic' ||
          keywordsArray[i] == '#relic' ||
          keywordsArray[i] == 'zoo' ||
          keywordsArray[i] == '#zoo') {
        _category = 6;
      }
      if (keywordsArray[i] == 'park' ||
          keywordsArray[i] == '#park' ||
          keywordsArray[i] == 'playground' ||
          keywordsArray[i] == '#playground' ||
          keywordsArray[i] == 'garden' ||
          keywordsArray[i] == '#garden' ||
          keywordsArray[i] == 'flowers' ||
          keywordsArray[i] == '#flowers' ||
          keywordsArray[i] == 'nationalpark' ||
          keywordsArray[i] == '#nationaprk' ||
          keywordsArray[i] == 'botanical' ||
          keywordsArray[i] == '#botanical') {
        _category = 7;
      }
      if (keywordsArray[i] == 'hotel' ||
          keywordsArray[i] == '#hotel' ||
          keywordsArray[i] == 'resturent' ||
          keywordsArray[i] == '#resturent' ||
          keywordsArray[i] == 'bar' ||
          keywordsArray[i] == '#bar' ||
          keywordsArray[i] == 'casino' ||
          keywordsArray[i] == '#casino' ||
          keywordsArray[i] == 'cafe' ||
          keywordsArray[i] == '#cafe' ||
          keywordsArray[i] == 'ballroom' ||
          keywordsArray[i] == '#ballroom' ||
          keywordsArray[i] == 'suite' ||
          keywordsArray[i] == '#suite' ||
          keywordsArray[i] == 'coffehouse' ||
          keywordsArray[i] == '#coffehouse') {
        _category = 8;
      }
    }
  }
}