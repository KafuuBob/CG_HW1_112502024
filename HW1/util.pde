public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // You need to implement the "line algorithm" in this section.
    // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
    // point at (114, 514).

    
     //stroke(0);
     //noFill();
     //line(x1,y1,x2,y2);
    int x1i = round(x1), y1i = round(y1);
    int x2i = round(x2), y2i = round(y2);
    int tmp;

    //太斜就把xy對調變成平緩的線
    boolean steep = abs(y2i - y1i) > abs(x2i - x1i);
    if (steep) {
        tmp = x1i; x1i = y1i; y1i = tmp;
        tmp = x2i; x2i = y2i; y2i = tmp;
    }

    //由右往走的線就把起點、終點對調
    if (x1i > x2i) {
        tmp = x1i; x1i = x2i; x2i = tmp;
        tmp = y1i; y1i = y2i; y2i = tmp;
    }

    //往上走時ystep改為-1
    int dx = x2i - x1i;
    int dy = abs(y2i - y1i);
    int ystep = (y1i < y2i) ? 1 : -1;

    int p = 2 * dy - dx;
    int y = y1i;
    for (int x = x1i; x <= x2i; x++) {
        if (steep) drawPoint(y, x, drawColor);
        else drawPoint(x, y, drawColor);

        if (p < 0) {
            p += 2 * dy;
        } else {
            y += ystep;
            p += 2 * dy - 2 * dx;
        }
    }
}

public void CGCircle(float x, float y, float r) {
    // TODO HW1
    // You need to implement the "circle algorithm" in this section.
    // You can use the function circle(x, y, r); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    
    //stroke(0);
    //noFill();
    //circle(x,y,r*2);

    int cx = round(x), cy = round(y);
    int R = round(r);
    int px = 0;
    int py = R;
    int p = 1 - R;
    // 只算正上方到 45° 這 1/8 圈，其餘用對稱補齊
    while (px <= py) {
        drawCirclePoints(cx, cy, px, py);
        px++;
        if (p < 0) {
            // 中點在圓內：y 不動
            p += 2 * px + 1;
        } else {
            // 中點在圓外：y 往圓心靠一格
            py--;
            p += 2 * px + 1 - 2 * py;
        }
    }
}

// (x, y) 是相對於圓心 (cx, cy) 的偏移量
void drawCirclePoints(int cx, int cy, int x, int y) {
    drawPoint(cx + x, cy + y, drawColor);
    drawPoint(cx - x, cy + y, drawColor);
    drawPoint(cx + x, cy - y, drawColor);
    drawPoint(cx - x, cy - y, drawColor);
    drawPoint(cx + y, cy + x, drawColor);
    drawPoint(cx - y, cy + x, drawColor);
    drawPoint(cx + y, cy - x, drawColor);
    drawPoint(cx - y, cy - x, drawColor);
}

public void CGEllipse(float x, float y, float r1, float r2) {
    // TODO HW1
    // You need to implement the "ellipse algorithm" in this section.
    // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
    // However, remember to comment out the function before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */

    int cx = round(x), cy = round(y);
    int rx = round(r1), ry = round(r2);
    // 其中一個半徑是 0 時，橢圓退化成一條線段
    if (rx == 0 || ry == 0) {
        CGLine(cx - rx, cy - ry, cx + rx, cy + ry);
        return;
    }

    // 數值會到 rx²·ry² 這麼大，用 double 避免 int 溢位和 float 精度不足
    double rx2 = (double) rx * rx;
    double ry2 = (double) ry * ry;
    int px = 0;
    int py = ry;
    double dx = 0;              // 2·ry²·px
    double dy = 2 * rx2 * py;   // 2·rx²·py

    // 區域 1：斜率 > -1，x 每步 +1，決定 y 要不要 -1
    double p = ry2 - rx2 * ry + 0.25 * rx2;
    while (dx < dy) {
        drawEllipsePoints(cx, cy, px, py);
        px++;
        dx += 2 * ry2;
        if (p < 0) {
            p += dx + ry2;
        } else {
            py--;
            dy -= 2 * rx2;
            p += dx - dy + ry2;
        }
    }

    // 區域 2：斜率 < -1，y 每步 -1，決定 x 要不要 +1
    p = ry2 * (px + 0.5) * (px + 0.5) + rx2 * (py - 1) * (py - 1) - rx2 * ry2;
    while (py >= 0) {
        drawEllipsePoints(cx, cy, px, py);
        py--;
        dy -= 2 * rx2;
        if (p > 0) {
            p += rx2 - dy;
        } else {
            px++;
            dx += 2 * ry2;
            p += dx - dy + rx2;
        }
    }
}

// 橢圓只有 4 分對稱，(x, y) 是相對於圓心 (cx, cy) 的偏移量
void drawEllipsePoints(int cx, int cy, int x, int y) {
    drawPoint(cx + x, cy + y, drawColor);
    drawPoint(cx - x, cy + y, drawColor);
    drawPoint(cx + x, cy - y, drawColor);
    drawPoint(cx - x, cy - y, drawColor);
}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    // TODO HW1
    // You need to implement the "bezier curve algorithm" in this section.
    // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
    // p4.y); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */

    // 曲線一定落在控制多邊形裡面，用它的長度估計要切幾段，
    // 每段大約 2 像素，再用 CGLine 把相鄰取樣點連起來，就不會有斷點
    float len = distance(p1, p2) + distance(p2, p3) + distance(p3, p4);
    int segments = max(1, ceil(len / 2));

    float prevX = p1.x, prevY = p1.y;
    for (int i = 1; i <= segments; i++) {
        float t = (float) i / segments;
        float u = 1 - t;
        // 三次 Bézier：B(t) = u³·P1 + 3u²t·P2 + 3ut²·P3 + t³·P4
        float b1 = u * u * u;
        float b2 = 3 * u * u * t;
        float b3 = 3 * u * t * t;
        float b4 = t * t * t;
        float curX = b1 * p1.x + b2 * p2.x + b3 * p3.x + b4 * p4.x;
        float curY = b1 * p1.y + b2 * p2.y + b3 * p3.y + b4 * p4.y;
        CGLine(prevX, prevY, curX, curY);
        prevX = curX;
        prevY = curY;
    }
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    // TODO HW1
    // You need to erase the scene in the area defined by points p1 and p2 in this
    // section.
    // p1 ------
    // |       |
    // |       |
    // ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    int left = round(min(p1.x, p2.x));
    int right = round(max(p1.x, p2.x));
    int top = round(min(p1.y, p2.y));
    int bottom = round(max(p1.y, p2.y));

    // 限制在畫布範圍內，避免在畫布外的白色邊框塗上灰色
    Box box = shapeRenderer.box;
    left = max(left, round(box.pos.x));
    right = min(right, round(box.pos.x + box.size.x));
    top = max(top, round(box.pos.y));
    bottom = min(bottom, round(box.pos.y + box.size.y));

    for (int i = left; i <= right; i++) {
        for (int j = top; j <= bottom; j++) {
            drawPoint(i, j, color(250));
        }
    }
}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
