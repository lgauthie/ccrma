//
//  WOGeometry.mm
//  wold
//
//  Created by Michael Rotondo on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WOGeometry.h"

#import "mo_gfx.h"
#import "Vector.hpp"
#import <vector>

// TODO: Use display lists to speed these bitches up.
@implementation WOGeometry

// TODO: Use triangle fans at the top and bottom instead of triangle strips, to have less redundancy?
+ (void)drawSphereWithRadius:(GLfloat)r andNumLats:(GLint)lats andNumLongs:(GLint)longs
{
    NSLog(@"SPHERE");
    
    GLfloat psi, theta, theta_next, x1, y1, z1, x2, y2, z2;
    
    for (int i = 0; i < lats + 1; i++) {
        
        int numVertices = 2 * longs;
        
        GLfloat vertices[numVertices * 3];
        GLfloat normals[numVertices * 3];
        GLfloat texCoords[numVertices * 2];
        
        theta = M_PI * (i / (float)(lats + 1));
        theta_next = M_PI * ((i + 1) / (float)(lats + 1));
        for (int j = 0; j < longs; j++) {
            psi = 2 * M_PI * (j / (float)(longs - 1));
            
            x1 = r * sin(theta) * cos(psi);
            y1 = r * sin(theta) * sin(psi);
            z1 = r * cos(theta);
            
            x2 = r * sin(theta_next) * cos(psi);
            y2 = r * sin(theta_next) * sin(psi);
            z2 = r * cos(theta_next);
            
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2] = x1;
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 1] = y1;
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 2] = z1;
            
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 3] = x2;
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 4] = y2;
            vertices[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 5] = z2;
            
            Vector3D norm1(x1, y1, z1);
            norm1.normalize();
            
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2] = norm1.x;
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 1] = norm1.y;
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 2] = norm1.z;
            
            Vector3D norm2(x2, y2, z2);
            norm2.normalize();
            
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 3] = norm2.x;
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 4] = norm2.y;
            normals[/*i * longs * 3 * 2 +*/ j * 3 * 2 + 5] = norm2.z;
            
            
            // SHITTY TEXTURE MAPPING
            texCoords[/*i * longs * 2 * 2 +*/ j * 2 * 2] = psi / (2 * M_PI);//sin(theta) * cos(psi);
            texCoords[/*i * longs * 2 * 2 +*/ j * 2 * 2 + 1] = theta / M_PI;//sin(theta) * sin(psi);
            
            texCoords[/*i * longs * 2 * 2 +*/ j * 2 * 2 + 2] = psi / (2 * M_PI);//sin(theta_next) * cos(psi);
            texCoords[/*i * longs * 2 * 2 +*/ j * 2 * 2 + 3] = theta_next / M_PI;//sin(theta_next) * sin(psi);
        }
        
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
        glVertexPointer(3, GL_FLOAT, 0, vertices);
        glNormalPointer(GL_FLOAT, 0, normals);
        glTexCoordPointer( 2, GL_FLOAT, 0, texCoords );
        glDrawArrays(GL_TRIANGLE_STRIP, 0, numVertices);
        
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }
}

struct Vertex {
    vec3 Position;
    vec3 Normal;
};

GLuint frustumVertexBuffer;
GLuint frustumIndexBuffer;

GLuint frustumIndexCount;
GLuint diskIndexCount;

const float bottomRadius = 1.0;
const float topRadius = 0.65;
const int numSlices = 5;
const float dtheta = M_PI * 2 / numSlices;
const int vertexCount = numSlices * 2 + 2;

+ (void)generateFrustum
{
    // GENERATE VERTICES
    std::vector<Vertex> frustumVertices(vertexCount);
    std::vector<Vertex>::iterator vertex = frustumVertices.begin();
    
    // body of frustum
    GLfloat x;
    for (float theta = 0; vertex != frustumVertices.end() - 2; theta += dtheta)
    { 
        x = theta / (2 * M_PI);
        NSLog(@"x: %f", x);
        
        vec3 position(bottomRadius * cos(theta), 0.0, bottomRadius * sin(theta));
        vertex->Position = position;
        vertex->Normal = position.Normalized();
        vertex++;
    
        position.x = topRadius * cos(theta);
        position.z = topRadius * sin(theta);
        vertex->Position = position;
        vertex->Position.y = 1.0;
        vertex->Normal = position.Normalized();
        vertex++;
    }
    
    vertex->Position = vec3(0, 0, 0);
    vertex->Normal = vec3(0, -1, 0);
    vertex++;
    vertex->Position = vec3(0, 1, 0);
    vertex->Normal = vec3(0, 1, 0);
    
    // GENERATE INDICES
    frustumIndexCount = numSlices * 2 * 3;
    diskIndexCount = numSlices * 3;

    std::vector<GLubyte> frustumIndices(frustumIndexCount + diskIndexCount * 2);
    std::vector<GLubyte>::iterator index = frustumIndices.begin();

    // BODY TRIANGLES
    for (int i = 0; i < numSlices * 2; i += 2) {
        *index++ = i;
        *index++ = (i + 1) % (2 * numSlices);
        *index++ = (i + 3) % (2 * numSlices);

        *index++ = i;
        *index++ = (i + 3) % (2 * numSlices);
        *index++ = (i + 2) % (2 * numSlices);
    }
    
    // BOTTOM DISK TRIANGLES
    const int bottomDiskCenterIndex = vertexCount - 2;
    for (int i = 0; i < numSlices * 2; i += 2) {
        *index++ = bottomDiskCenterIndex;
        *index++ = i;
        *index++ = (i + 2) % (2 * numSlices);
    }

    // TOP DISK TRIANGLES
    // NOTE: each triangle wound in reverse so that it doesn't think it's a backface
    const int topDiskCenterIndex = vertexCount - 1;
    for (int i = 1; i < numSlices * 2 + 1; i += 2) {
        *index++ = topDiskCenterIndex;
        *index++ = (i + 2) % (2 * numSlices);
        *index++ = i;
    }
    
    // Create the VBO for the vertices
    glGenBuffers(1, &frustumVertexBuffer);
    
    GLenum err = glGetError();
    NSLog(@"Err: %d", err);
    
    if(glIsBuffer(frustumVertexBuffer))
        printf("I'm a buffer!\n");	// Never gets here
    
    glBindBuffer(GL_ARRAY_BUFFER, frustumVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, frustumVertices.size() * sizeof(frustumVertices[0]), &frustumVertices[0], GL_STATIC_DRAW);
    
    // Create the VBO for the indices
    glGenBuffers(1, &frustumIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, frustumIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, frustumIndices.size() * sizeof(frustumIndices[0]), &frustumIndices[0], GL_STATIC_DRAW);
}

+ (void)startDrawingFrustums
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, frustumIndexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, frustumVertexBuffer);

    glVertexPointer(3, GL_FLOAT, sizeof(Vertex), 0);
    const GLvoid* normalOffset = (GLvoid*)sizeof(vec3);
    glNormalPointer(GL_FLOAT, sizeof(Vertex), normalOffset);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
}

+ (void)stopDrawingFrustums
{
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

+ (void)drawFrustumWithBottomRadius:(GLfloat)rBottom andTopRadius:(GLfloat)rTop andHeight:(GLfloat)h andSections:(GLint)sections
{
    //NSLog(@"%d", counter++);
    
    glPushMatrix();
    glScalef(rBottom, h, rBottom); // suboptimal
    
    const GLvoid* frustumOffset = 0;
    const GLvoid* bottomDiskOffset = (GLvoid*)frustumIndexCount;
    const GLvoid* topDiskOffset = (GLvoid*)(frustumIndexCount + diskIndexCount);
    
    glDrawElements(GL_TRIANGLES, frustumIndexCount, GL_UNSIGNED_BYTE, frustumOffset);
    glDrawElements(GL_TRIANGLES, diskIndexCount, GL_UNSIGNED_BYTE, bottomDiskOffset);
    glDrawElements(GL_TRIANGLES, diskIndexCount, GL_UNSIGNED_BYTE, topDiskOffset);
    
    glPopMatrix();
}

//+ (void)drawFrustumWithBottomRadius:(GLfloat)rBottom andTopRadius:(GLfloat)rTop andHeight:(GLfloat)h andSections:(GLint)sections
//{
//    GLsizei stride = sizeof(Vertex);
//    const GLvoid* pCoords = &frustumVertices[0].Position.x;
//    const GLvoid* pColors = &frustumVertices[0].Color.x;
//    const GLvoid* pNormals = &frustumVertices[0].Normal.x;
//    const GLvoid* pTexCoords = &frustumVertices[0].TexCoord.x;
//    
//    glPushMatrix();
//    glScalef(rBottom, h, rBottom);
//    glVertexPointer(3, GL_FLOAT, stride, pCoords);
//    glColorPointer(4, GL_FLOAT, stride, pColors);
//    glNormalPointer(GL_FLOAT, stride, pNormals);
//    glTexCoordPointer(2, GL_FLOAT, stride, pTexCoords); // TODO: Figure out why textures don't seem to be working for frustums
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_COLOR_ARRAY);
//    glEnableClientState(GL_NORMAL_ARRAY);
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//    const GLvoid* bodyIndices = &frustumIndices[0];
//    const GLvoid* bottomDiskIndices = &frustumIndices[frustumIndexCount];
//    const GLvoid* topDiskIndices = &frustumIndices[frustumIndexCount + diskIndexCount];
//    
//    glDrawElements(GL_TRIANGLES, frustumIndexCount, GL_UNSIGNED_BYTE, bodyIndices);
//    glDrawElements(GL_TRIANGLES, diskIndexCount, GL_UNSIGNED_BYTE, bottomDiskIndices);
//    glDrawElements(GL_TRIANGLES, diskIndexCount, GL_UNSIGNED_BYTE, topDiskIndices);
//    
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_COLOR_ARRAY);
//    glDisableClientState(GL_NORMAL_ARRAY);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    glPopMatrix();
//}

//// Globals so I can use them from class methods
//GLfloat* tubeVertices;
//GLfloat* tubeNormals;
//GLfloat* tubeTexCoords;
//
//int numTubeVertices;
//int numFanVertices;
//
//// NEW HOTNESS using vertex indexing and drawElements
//GLfloat* frustumVertices;
////GLubyte* frustumIndices;
//
//+ (void)generateFrustum
//{
//    GLfloat rBottom = 1.0; // Scale me later!
//    GLfloat rTop = 0.65; // Like our tree frustums, duh!
//    GLfloat h = 1.0; // Scale me later!
//    int sections = 5; // Like our trees, again.
//    
//    numTubeVertices = (sections + 1) * 2;
//    numFanVertices = sections + 2;
//    
//    frustumVertices = new GLfloat[numTubeVertices + (numFanVertices * 2) * 3];
//    int vertexIndex = 0;
//    
//    bottomFanNormals = new GLfloat[numFanVertices * 3];
//    bottomFanTexCoords = new GLfloat[numFanVertices * 2];
//    
//    frustumVertices[vertexIndex * 3] = 0.0f;
//    frustumVertices[vertexIndex * 3 + 1] = 0.0f;
//    frustumVertices[vertexIndex * 3 + 2] = 0.0f;
//    vertexIndex++;
//    
//    bottomFanNormals[0] = 0.0f;
//    bottomFanNormals[1] = -1.0f;
//    bottomFanNormals[2] = 0.0f;
//    
//    bottomFanTexCoords[0] = 0.5;
//    bottomFanTexCoords[1] = 0.5;
//    
//    topFanVertices = new GLfloat[numFanVertices * 3];
//    topFanNormals = new GLfloat[numFanVertices * 3];
//    topFanTexCoords = new GLfloat[numFanVertices * 2];
//    topFanVertices[0] = 0.0f;
//    topFanVertices[1] = h;
//    topFanVertices[2] = 0.0f;
//    
//    topFanNormals[0] = 0.0f;
//    topFanNormals[1] = 1.0f;
//    topFanNormals[2] = 0.0f;
//    
//    topFanTexCoords[0] = 0.5;
//    topFanTexCoords[1] = 0.5;
//    
//    tubeVertices = new GLfloat[numTubeVertices * 3];
//    tubeNormals = new GLfloat[numTubeVertices * 3];
//    tubeTexCoords = new GLfloat[numTubeVertices * 2];
//    
//    GLfloat percent, theta, bottomX, topX, bottomZ, topZ;
//    Vector3D norm;
//    for( int i = 0; i < numFanVertices - 1; i++) {
//        percent = i / (GLfloat)(numFanVertices - 2);
//        theta = 2 * M_PI * percent;
//        
//        bottomX = rBottom * cos(theta);
//        bottomZ = rBottom * sin(theta);
//        topX = rTop * cos(theta);
//        topZ = rTop * sin(theta);
//        
//        bottomFanVertices[(i + 1) * 3] = bottomX;
//        bottomFanVertices[(i + 1) * 3 + 1] = 0.0f;
//        bottomFanVertices[(i + 1) * 3 + 2] = bottomZ;
//        
//        bottomFanNormals[(i + 1) * 3] = 0.0f;
//        bottomFanNormals[(i + 1) * 3 + 1] = -1.0f;
//        bottomFanNormals[(i + 1) * 3 + 2] = 0.0f;
//        
//        bottomFanTexCoords[(i + 1) * 2] = 0.5 + bottomX / 2;
//        bottomFanTexCoords[(i + 1) * 2 + 1] = 0.5 + bottomZ / 2;
//        
//        // NOTE: This is written in reverse so that it winds correctly and OpenGL recognizes it as facing in the opposite direction from the bottom
//        topFanVertices[(numFanVertices - (i + 1)) * 3] = topX;
//        topFanVertices[(numFanVertices - (i + 1)) * 3 + 1] = h;
//        topFanVertices[(numFanVertices - (i + 1)) * 3 + 2] = topZ;
//        
//        topFanNormals[(i + 1) * 3] = 0.0f;
//        topFanNormals[(i + 1) * 3 + 1] = 1.0f;
//        topFanNormals[(i + 1) * 3 + 2] = 0.0f;
//        
//        topFanTexCoords[(i + 1) * 2] = 0.5 + topX / 2;
//        topFanTexCoords[(i + 1) * 2 + 1] = 0.5 + topZ / 2;
//        
//        tubeVertices[i * 3 * 2] = bottomX;
//        tubeVertices[i * 3 * 2 + 1] = 0.0f;
//        tubeVertices[i * 3 * 2 + 2] = bottomZ;
//        tubeVertices[i * 3 * 2 + 3] = topX;
//        tubeVertices[i * 3 * 2 + 4] = h;
//        tubeVertices[i * 3 * 2 + 5] = topZ;
//        
//        norm.x = bottomX;
//        norm.z = bottomZ;
//        norm.normalize();
//        tubeNormals[i * 3 * 2] = norm.x;
//        tubeNormals[i * 3 * 2 + 1] = 0.0f;
//        tubeNormals[i * 3 * 2 + 2] = norm.z;
//        norm.x = topX;
//        norm.z = topZ;
//        norm.normalize();
//        tubeNormals[i * 3 * 2 + 3] = norm.x;
//        tubeNormals[i * 3 * 2 + 4] = 0.0f;
//        tubeNormals[i * 3 * 2 + 5] = norm.z;
//        
//        tubeTexCoords[i * 2 * 2] = percent;
//        tubeTexCoords[i * 2 * 2 + 1] = 0.0f;
//        tubeTexCoords[i * 2 * 2 + 2] = percent;
//        tubeTexCoords[i * 2 * 2 + 3] = 1.0f;
//    }
//}
//
//+ (void)drawFrustumWithBottomRadius:(GLfloat)rBottom andTopRadius:(GLfloat)rTop andHeight:(GLfloat)h andSections:(GLint)sections
//{
//    glPushMatrix();
//    glScalef(rBottom, h, rBottom);  // TODO: This non-uniform scale could be hurting performance
//    
//    glVertexPointer(3, GL_FLOAT, 0, tubeVertices);
//    glNormalPointer(GL_FLOAT, 0, tubeNormals);
//    glTexCoordPointer( 2, GL_FLOAT, 0, tubeTexCoords );
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, numTubeVertices);
//
//    glVertexPointer(3, GL_FLOAT, 0, bottomFanVertices);
//    glNormalPointer(GL_FLOAT, 0, bottomFanNormals);
//    glTexCoordPointer( 2, GL_FLOAT, 0, bottomFanTexCoords );
//    glDrawArrays(GL_TRIANGLE_FAN, 0, numFanVertices);
//
//    glVertexPointer(3, GL_FLOAT, 0, topFanVertices);
//    glNormalPointer(GL_FLOAT, 0, topFanNormals);
//    glTexCoordPointer( 2, GL_FLOAT, 0, topFanTexCoords );
//    glDrawArrays(GL_TRIANGLE_FAN, 0, numFanVertices);
//    
//    glPopMatrix();
//}


// SADNESS but I need these in class methods.
// Disk geometry:
GLfloat* diskBottomVertices;
GLfloat* diskBottomNormals;
GLfloat* diskBottomTexCoords;
GLfloat* diskTopVertices;
GLfloat* diskTopNormals;
GLfloat* diskTopTexCoords;
int numDiskVertices;

+ (void) generateDisk
{
    // Assume 5 sections (like leaves have, duh)
    int sections = 5;
    GLfloat h = 0.0001;
    GLfloat r = 1.0; // Scale it later!
    numDiskVertices = sections + 2;
    
    diskBottomVertices = new GLfloat[numDiskVertices * 3];
    diskBottomNormals = new GLfloat[numDiskVertices * 3];
    diskBottomTexCoords = new GLfloat[numDiskVertices * 2];
    diskBottomVertices[0] = 0.0f;
    diskBottomVertices[1] = 0.0f;
    diskBottomVertices[2] = 0.0f;
    
    diskBottomNormals[0] = 0.0f;
    diskBottomNormals[1] = -1.0f;
    diskBottomNormals[2] = 0.0f;
    
    diskBottomTexCoords[0] = 0.5;
    diskBottomTexCoords[1] = 0.5;
    
    diskTopVertices = new GLfloat[numDiskVertices * 3];
    diskTopNormals = new GLfloat[numDiskVertices * 3];
    diskTopTexCoords = new GLfloat[numDiskVertices * 2];
    diskTopVertices[0] = 0.0f;
    diskTopVertices[1] = h;
    diskTopVertices[2] = 0.0f;
    
    diskTopNormals[0] = 0.0f;
    diskTopNormals[1] = 1.0f;
    diskTopNormals[2] = 0.0f;
    
    diskTopTexCoords[0] = 0.5;
    diskTopTexCoords[1] = 0.5;
    
    GLfloat percent, theta, x, z;
    Vector3D norm;
    for( int i = 0; i < numDiskVertices - 1; i++) {
        percent = i / (GLfloat)(numDiskVertices - 2);
        theta = 2 * M_PI * percent;
        
        x = r * cos(theta);
        z = r * sin(theta);
        
        diskBottomVertices[(i + 1) * 3] = x;
        diskBottomVertices[(i + 1) * 3 + 1] = 0.0f;
        diskBottomVertices[(i + 1) * 3 + 2] = z;
        
        diskBottomNormals[(i + 1) * 3] = 0.0f;
        diskBottomNormals[(i + 1) * 3 + 1] = -1.0f;
        diskBottomNormals[(i + 1) * 3 + 2] = 0.0f;
        
        diskBottomTexCoords[(i + 1) * 2] = 0.5 + x / 2;
        diskBottomTexCoords[(i + 1) * 2 + 1] = 0.5 + z / 2;
        
        // NOTE: This is written in reverse so that it winds correctly and OpenGL recognizes it as facing in the opposite direction from the bottom
        diskTopVertices[(numDiskVertices - (i + 1)) * 3] = x;
        diskTopVertices[(numDiskVertices - (i + 1)) * 3 + 1] = h;
        diskTopVertices[(numDiskVertices - (i + 1)) * 3 + 2] = z;
        
        diskTopNormals[(i + 1) * 3] = 0.0f;
        diskTopNormals[(i + 1) * 3 + 1] = 1.0f;
        diskTopNormals[(i + 1) * 3 + 2] = 0.0f;
        
        diskTopTexCoords[(i + 1) * 2] = 0.5 + x / 2;
        diskTopTexCoords[(i + 1) * 2 + 1] = 0.5 + z / 2;
    }

}

+ (void)drawDiskWithRadius:(GLfloat)r andSections:(GLint)sections
{
    NSLog(@"DISK");
    
    glPushMatrix();
    glScalef(r, 1.0, r);  // TODO: This non-uniform scale could be hurting performance
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, diskBottomVertices);
    glNormalPointer(GL_FLOAT, 0, diskBottomNormals);
    glTexCoordPointer( 2, GL_FLOAT, 0, diskBottomTexCoords );
    glDrawArrays(GL_TRIANGLE_FAN, 0, numDiskVertices);
     
    glVertexPointer(3, GL_FLOAT, 0, diskTopVertices);
    glNormalPointer(GL_FLOAT, 0, diskTopNormals);
    glTexCoordPointer( 2, GL_FLOAT, 0, diskTopTexCoords );
    glDrawArrays(GL_TRIANGLE_FAN, 0, numDiskVertices);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glPopMatrix();
}

//+ (void)drawDiskWithRadius:(GLfloat)r andSections:(GLint)sections
//{
//    GLfloat h = 0.0001;
//    int numFanVertices = sections + 2;
//    
//    GLfloat bottomFanVertices[numFanVertices * 3];
//    GLfloat bottomFanNormals[numFanVertices * 3];
//    GLfloat bottomFanTexCoords[numFanVertices * 2];
//    bottomFanVertices[0] = 0.0f;
//    bottomFanVertices[1] = 0.0f;
//    bottomFanVertices[2] = 0.0f;
//    
//    bottomFanNormals[0] = 0.0f;
//    bottomFanNormals[1] = -1.0f;
//    bottomFanNormals[2] = 0.0f;
//    
//    bottomFanTexCoords[0] = 0.5;
//    bottomFanTexCoords[1] = 0.5;
//    
//    GLfloat topFanVertices[numFanVertices * 3];
//    GLfloat topFanNormals[numFanVertices * 3];
//    GLfloat topFanTexCoords[numFanVertices * 2];
//    topFanVertices[0] = 0.0f;
//    topFanVertices[1] = h;
//    topFanVertices[2] = 0.0f;
//    
//    topFanNormals[0] = 0.0f;
//    topFanNormals[1] = 1.0f;
//    topFanNormals[2] = 0.0f;
//    
//    topFanTexCoords[0] = 0.5;
//    topFanTexCoords[1] = 0.5;
//    
//    GLfloat percent, theta, x, z;
//    Vector3D norm;
//    for( int i = 0; i < numFanVertices - 1; i++) {
//        percent = i / (GLfloat)(numFanVertices - 2);
//        theta = 2 * M_PI * percent;
//        
//        x = r * cos(theta);
//        z = r * sin(theta);
//        
//        bottomFanVertices[(i + 1) * 3] = x;
//        bottomFanVertices[(i + 1) * 3 + 1] = 0.0f;
//        bottomFanVertices[(i + 1) * 3 + 2] = z;
//        
//        bottomFanNormals[(i + 1) * 3] = 0.0f;
//        bottomFanNormals[(i + 1) * 3 + 1] = -1.0f;
//        bottomFanNormals[(i + 1) * 3 + 2] = 0.0f;
//        
//        bottomFanTexCoords[(i + 1) * 2] = 0.5 + x / 2;
//        bottomFanTexCoords[(i + 1) * 2 + 1] = 0.5 + z / 2;
//        
//        // NOTE: This is written in reverse so that it winds correctly and OpenGL recognizes it as facing in the opposite direction from the bottom
//        topFanVertices[(numFanVertices - (i + 1)) * 3] = x;
//        topFanVertices[(numFanVertices - (i + 1)) * 3 + 1] = h;
//        topFanVertices[(numFanVertices - (i + 1)) * 3 + 2] = z;
//        
//        topFanNormals[(i + 1) * 3] = 0.0f;
//        topFanNormals[(i + 1) * 3 + 1] = 1.0f;
//        topFanNormals[(i + 1) * 3 + 2] = 0.0f;
//        
//        topFanTexCoords[(i + 1) * 2] = 0.5 + x / 2;
//        topFanTexCoords[(i + 1) * 2 + 1] = 0.5 + z / 2;
//    }
//
//    glVertexPointer(3, GL_FLOAT, 0, bottomFanVertices);
//    glNormalPointer(GL_FLOAT, 0, bottomFanNormals);
//    glTexCoordPointer( 2, GL_FLOAT, 0, bottomFanTexCoords );
//    glDrawArrays(GL_TRIANGLE_FAN, 0, numFanVertices);
//    
//    glVertexPointer(3, GL_FLOAT, 0, topFanVertices);
//    glNormalPointer(GL_FLOAT, 0, topFanNormals);
//    glTexCoordPointer( 2, GL_FLOAT, 0, topFanTexCoords );
//    glDrawArrays(GL_TRIANGLE_FAN, 0, numFanVertices);
//}


@end
