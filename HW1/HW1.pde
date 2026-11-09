ShapeButton lineButton;
ShapeButton circleButton;
ShapeButton polygonButton;
ShapeButton ellipseButton;
ShapeButton curveButton;
ShapeButton pencilButton;
ShapeButton eraserButton;
Button clearButton;

color currentColor = color(0); // 使用者在調色盤選的顏色
color drawColor = color(0);    // CG 函式「現在」要用的顏色

color[] palette = {
    color(0), color(255, 0, 0), color(255, 150, 0), color(255, 220, 0),
    color(0, 180, 0), color(0, 120, 255), color(130, 0, 200), color(255, 255, 255)
};
ArrayList<Button> colorButtons;

    
ShapeRenderer shapeRenderer;
ArrayList<ShapeButton> shapeButton;
float eraserSize = 20;

public void setup() {
    size(1000, 800);
    background(255);
    shapeRenderer = new ShapeRenderer();
    initButton();

}

public void draw() {

    background(255);
    for (ShapeButton sb : shapeButton) {
        sb.run(() -> {
            sb.beSelect();
            shapeRenderer.setRenderer(sb.getRendererType());
        });
    }

    clearButton.run(() -> {
        shapeRenderer.clear();
    });

    for (int i = 0; i < colorButtons.size(); i++) {
        final color c = palette[i];
        colorButtons.get(i).run(() -> {
            currentColor = c ;
        });
    }
    for (int i = 0; i < colorButtons.size(); i++) {
    Button b = colorButtons.get(i);
    noFill();
    if (currentColor == palette[i]) {
        stroke(255, 0, 0);
        noFill();
        rect(b.pos.x - 2, b.pos.y - 2, b.size.x + 4,b.size.y + 4);
    } else {
        // 沒被選中：灰色框，跟按鈕一樣大
        stroke(150);
        noFill();
        rect(b.pos.x , b.pos.y , b.size.x ,b.size.y );
    }
}

    shapeRenderer.box.show();

    shapeRenderer.run();

}

void resetButton() {
    for (ShapeButton sb : shapeButton) {
        sb.setSelected(false);
    }
}

public void initButton() {
    shapeButton = new ArrayList<ShapeButton>();
    lineButton = new ShapeButton(10, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new LineRenderer();
        }
    };

    lineButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(lineButton);

    circleButton = new ShapeButton(45, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            circle(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new CircleRenderer();
        }
    };
    circleButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(circleButton);

    polygonButton = new ShapeButton(80, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + 2);
            line(pos.x + 2, pos.y + size.y - 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + size.x - 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + 2, pos.y + 2, pos.x + 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new PolygonRenderer();
        }

    };

    polygonButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(polygonButton);

    ellipseButton = new ShapeButton(115, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            ellipse(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2, size.y * 2 / 3);
        }

        @Override
        public Renderer getRendererType() {
            return new EllipseRenderer();
        }

    };

    ellipseButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(ellipseButton);

    curveButton = new ShapeButton(150, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            bezier(pos.x, pos.y, pos.x, pos.y + size.y, pos.x + size.x, pos.y, pos.x + size.x, pos.y + size.y);
        }

        @Override
        public Renderer getRendererType() {
            return new CurveRenderer();
        }

    };

    curveButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(curveButton);

    clearButton = new Button(width - 50, 10, 30, 30);
    clearButton.setBoxAndClickColor(color(250), color(150));
    clearButton.setImage(loadImage("clear.png"));

    pencilButton = new ShapeButton(185, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new PencilRenderer();
        }
    };
    pencilButton.setImage(loadImage("pencil.png"));

    pencilButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(pencilButton);

    eraserButton = new ShapeButton(220, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new EraserRenderer();
        }
    };
    eraserButton.setImage(loadImage("eraser.png"));

    eraserButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(eraserButton);

    colorButtons = new ArrayList<Button>();
    for (int i = 0; i < palette.length; i++) {
        Button b = new Button(270 + i*35, 10, 30, 30);
        b.setBoxAndClickColor(palette[i], color(150));
        colorButtons.add(b);
    }
}

public void keyPressed() {
    if (key == 'z' || key == 'Z') {
        shapeRenderer.popShape();
    }
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (e < 0)
        eraserSize += 1;
    else if (e > 0)
        eraserSize -= 1;
    eraserSize = max(min(eraserSize, 30), 4);
}
