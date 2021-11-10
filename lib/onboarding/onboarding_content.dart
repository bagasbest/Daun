class OnBoardingContent {
  var image;
  var description;

  OnBoardingContent({this.image, this.description});

}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    image: 'assets/image/one.png',
    description: 'Sekarang saat nya menjadi petani milenial dengan hidroponik',
  ),
  OnBoardingContent(
    image: 'assets/image/two.png',
    description: 'Semua bisa memulainya dari halaman rumah sendiri',
  ),
  OnBoardingContent(
    image: 'assets/image/three.png',
    description: 'Kapan lagi kalau bukan sekarang? yukk mulai..',
  )
];
