//
//  Boxes.vsh
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec3 color;

varying lowp vec3 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
  vec3 eyeNormal = normalize(normalMatrix * normal);
  vec3 lightPosition = vec3(4.0, 4.0, 4.0);
  
  // a subtractive fog?
  vec3 fogColor = vec3(0.5, 0.5, 0.5);
    
  float nDotVP = abs(dot(eyeNormal, normalize(lightPosition)));

  gl_Position = modelViewProjectionMatrix * position;

  colorVarying = color * nDotVP +
     (5.0 - (gl_Position[2] + 1.0)) / 5.0 * fogColor;
}
